# Intersection.gd
extends Area2D

@export var intersection_id: int = 0

@onready var path1_wall = $stair1Barrier
@onready var path1_collision = $stair1Barrier/CollisionShape2D
@onready var path2_wall = $stair2Barrier
@onready var path2_collision = $stair2Barrier/CollisionShape2D

var question_data = null
var player = null
var has_answered = false
var question_ui = null

func _ready():
	if intersection_id >= 0 and intersection_id < Questions.questions.size():
		question_data = Questions.questions[intersection_id]
	else:
		push_error("Invalid intersection_id: " + str(intersection_id))

	# Remove the programmatic connection since it's now connected in the editor
	# if not is_connected("body_entered", Callable(self, "_on_body_entered")):
	#     connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	print("Body entered intersection ", intersection_id, ": ", body.name)
	if body.is_in_group("player") and not has_answered:
		print("Player detected at intersection ", intersection_id)
		player = body
		print("Stopping player movement")
		player.velocity = Vector2.ZERO  # Comment out for now
		print("Calling show_question for intersection ", intersection_id)
		show_question()
	else:
		print("Body is not the player or already answered: ", body.name, ", has_answered: ", has_answered)

func show_question():
	print("Inside show_question for intersection ", intersection_id)
	print("Question data: ", question_data)
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 0
	print("Adding CanvasLayer to scene tree")
	get_tree().root.add_child(canvas_layer)

	question_ui = Control.new()
	var viewport_size = get_viewport().get_visible_rect().size
	question_ui.position = viewport_size / 2 - Vector2(200, 100)  # Center the UI (size is 400x200)
	question_ui.size = Vector2(400, 200)
	print("Viewport size: ", viewport_size, ", UI position: ", question_ui.position)

	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.8)
	background.size = Vector2(400, 200)
	question_ui.add_child(background)
	print("Created question_ui Control node with background")

	var question_label = Label.new()
	question_label.text = question_data["question"]
	question_label.position = Vector2(0, 0)
	var font = SystemFont.new()
	font.font_names = ["Arial"]
	question_label.add_theme_font_override("font", font)
	question_label.add_theme_font_size_override("font_size", 24)
	question_label.add_theme_color_override("font_color", Color(1, 1, 1))
	question_ui.add_child(question_label)
	print("Added question_label to question_ui")

	var correct_button = Button.new()
	correct_button.text = question_data["correct_answer"]
	correct_button.position = Vector2(0, 50)
	correct_button.size = Vector2(150, 50)
	correct_button.add_theme_font_override("font", font)
	correct_button.add_theme_font_size_override("font_size", 20)
	correct_button.connect("pressed", Callable(self, "_on_answer").bind(true))
	question_ui.add_child(correct_button)
	print("Added correct_button to question_ui")

	var wrong_button = Button.new()
	wrong_button.text = question_data["wrong_answer"]
	wrong_button.position = Vector2(200, 50)
	wrong_button.size = Vector2(150, 50)
	wrong_button.add_theme_font_override("font", font)
	wrong_button.add_theme_font_size_override("font_size", 20)
	wrong_button.connect("pressed", Callable(self, "_on_answer").bind(false))
	question_ui.add_child(wrong_button)
	print("Added wrong_button to question_ui")

	print("Adding question UI to CanvasLayer for intersection ", intersection_id)
	canvas_layer.add_child(question_ui)
func _on_answer(is_correct):
	print("Answer selected: is_correct = ", is_correct)  # Debug print
	has_answered = true
	if question_ui:
		var canvas_layer = question_ui.get_parent()
		question_ui.queue_free()
		question_ui = null
		canvas_layer.queue_free()

	var correct_path = question_data["correct_path"]
	var wrong_path = question_data["wrong_path"]

	if is_correct:
		if correct_path == "Path1":
			print(3)
			path1_wall.visible = false
			print(4)
			path1_collision.queue_free()
		else:
			path2_wall.visible = false
			path2_collision.queue_free()
	else:
		if wrong_path == "Path1":
			path1_wall.visible = false
			path1_collision.queue_free()
		else:
			path2_wall.visible = false
			path2_collision.queue_free()

	player.velocity = Vector2.ZERO
