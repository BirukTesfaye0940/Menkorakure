extends "res://addons/gut/test.gd"

var Intersection = preload("res://Level1/scenes/intersection.gd")
var intersection = null
var mock_player = null
var mock_wall = null
var mock_collision = null

func before_each():
	# Create mock objects
	intersection = Intersection.new()
	mock_player = Node2D.new()
	mock_wall = Node2D.new()
	mock_collision = CollisionShape2D.new()
	
	# Set up mock player
	mock_player.add_to_group("player")
	
	# Set up intersection properties
	intersection.questions = [
		{
			"question": "Test question?",
			"correct_answer": "Yes",
			"wrong_answer": "No",
			"correct_path": "Path1",
			"wrong_path": "Path2"
		}
	]
	intersection.intersection_id = 0
	intersection.path1_wall = mock_wall
	intersection.path2_wall = mock_wall
	intersection.path1_collision = mock_collision
	intersection.path2_collision = mock_collision
	
	# Add to scene tree for signal testing
	add_child_autoqfree(intersection)
	add_child_autoqfree(mock_player)

func after_each():
	# Clean up
	intersection.free()
	mock_player.free()
	mock_wall.free()
	mock_collision.free()

func test_ready_valid_intersection_id():
	# Test _ready with valid intersection_id
	intersection._ready()
	assert_eq(intersection.question_data, intersection.questions[0], "Question data should be set for valid intersection_id")

func test_ready_invalid_intersection_id():
	# Test _ready with invalid intersection_id
	gut.p("Testing invalid intersection_id")
	var error_output = gut.get_logger().get_errors()
	intersection.intersection_id = 999
	intersection._ready()
	var errors = gut.get_logger().get_errors()
	assert_gt(errors.size(), error_output.size(), "Should log an error for invalid intersection_id")

func test_on_body_entered_player():
	# Test _on_body_entered with player
	intersection.has_answered = false
	intersection._on_body_entered(mock_player)
	assert_eq(intersection.player, mock_player, "Player should be set when entering")
	assert_true(intersection.has_answered, "has_answered should be true after question is shown")

func test_on_body_entered_non_player():
	# Test _on_body_entered with non-player
	var non_player = Node2D.new()
	add_child_autoqfree(non_player)
	intersection.has_answered = false
	intersection._on_body_entered(non_player)
	assert_null(intersection.player, "Player should not be set for non-player")
	assert_false(intersection.has_answered, "has_answered should remain false for non-player")
	non_player.free()

func test_on_body_entered_already_answered():
	# Test _on_body_entered when already answered
	intersection.has_answered = true
	intersection._on_body_entered(mock_player)
	assert_null(intersection.player, "Player should not be set if already answered")

func test_show_question_ui_creation():
	# Test show_question creates UI elements
	intersection.show_question()
	assert_not_null(intersection.question_ui, "Question UI should be created")
	assert_eq(intersection.question_ui.get_child_count(), 3, "Question UI should have background, label, and two buttons")
	
	# Verify canvas layer
	var canvas_layer = intersection.question_ui.get_parent()
	assert_true(canvas_layer is CanvasLayer, "Question UI should be child of CanvasLayer")

func test_on_answer_correct():
	# Test _on_answer with correct answer
	intersection.show_question()
	intersection._on_answer(true)
	assert_null(intersection.question_ui, "Question UI should be freed after answering")
	assert_false(intersection.path1_wall.visible, "Path1 wall should be invisible for correct answer")
	assert_false(intersection.path1_collision.get_parent(), "Path1 collision should be freed")

func test_on_answer_wrong():
	# Test _on_answer with wrong answer
	intersection.show_question()
	intersection._on_answer(false)
	assert_null(intersection.question_ui, "Question UI should be freed after answering")
	assert_false(intersection.path2_wall.visible, "Path2 wall should be invisible for wrong answer")
	assert_false(intersection.path2_collision.get_parent(), "Path2 collision should be freed")

func test_player_velocity_reset():
	# Test player velocity reset after answering
	mock_player.velocity = Vector2(100, 100)
	intersection.show_question()
	intersection._on_answer(true)
	assert_eq(mock_player.velocity, Vector2.ZERO, "Player velocity should be reset after answering")
