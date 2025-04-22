extends "res://addons/gut/test.gd"

var SharpStones = load("res://level5/scenes/sharpstones.tscn")
var sharp_stones: Area2D
var test_player: CharacterBody2D

func before_all():
	# This runs once before all tests
	pass

func before_each():
	# This runs before each test
	sharp_stones = autofree(SharpStones.instantiate())
	test_player = autofree(CharacterBody2D.new())
	test_player.add_to_group("player")
	
	# Mock the player's take_damage method with a spy
	test_player.take_damage = func(_amount): pass
	stub(test_player, "take_damage").to_do_nothing()

func after_each():
	# This runs after each test
	pass

func after_all():
	# This runs after all tests
	pass

func test_signal_connections_are_set_up_in_ready():
	# Verify signals are connected in _ready
	sharp_stones._ready()
	
	assert_connected(sharp_stones, sharp_stones, "body_entered", "_on_body_entered",
		"SharpStones should connect body_entered signal to _on_body_entered")
	
	assert_connected(sharp_stones.timer, sharp_stones, "timeout", "_on_timer_timeout",
		"Timer should connect timeout signal to _on_timer_timeout")

func test_on_body_entered_starts_timer_when_player_enters():
	# When player enters, timer should start
	watch_signals(sharp_stones.timer)
	
	sharp_stones._on_body_entered(test_player)
	
	assert_false(sharp_stones.timer.is_stopped(), "Timer should start when player enters")
	assert_signal_emitted(sharp_stones.timer, "timeout", 
		"Timer should be set up to emit timeout signal")

func test_timer_timeout_calls_take_damage_on_player():
	# Verify damage is applied to player on timeout
	var damage_spy = spy(test_player, "take_damage")
	
	sharp_stones._on_timer_timeout()
	
	assert_called(damage_spy, "take_damage", [sharp_stones.damage],
		"Player's take_damage should be called with correct damage amount")

func test_timer_timeout_respawns_player_at_correct_position():
	# Test player respawn position calculation
	var initial_pos = Vector2(500, 300)
	test_player.global_position = initial_pos
	
	sharp_stones._on_timer_timeout()
	
	var expected_x = initial_pos.x + sharp_stones.respawn_distance_x
	var expected_y = initial_pos.y + sharp_stones.respawn_distance_y
	var expected_pos = Vector2(expected_x, expected_y)
	
	assert_eq(test_player.global_position, expected_pos, 
		"Player should be respawned at correct offset position")

func test_only_character_body_triggers_timer():
	# Verify only CharacterBody2D nodes trigger the effect
	var static_body = autofree(StaticBody2D.new())
	var other_area = autofree(Area2D.new())
	
	watch_signals(sharp_stones.timer)
	
	sharp_stones._on_body_entered(static_body)
	assert_true(sharp_stones.timer.is_stopped(), 
		"Timer should not start for StaticBody2D")
	
	sharp_stones._on_body_entered(other_area)
	assert_true(sharp_stones.timer.is_stopped(), 
		"Timer should not start for Area2D")
	
	sharp_stones._on_body_entered(test_player)
	assert_false(sharp_stones.timer.is_stopped(), 
		"Timer should start for CharacterBody2D")

func test_exported_variables_have_correct_default_values():
	# Test that exported variables have expected default values
	assert_eq(sharp_stones.damage, 100.0, "Default damage should be 100")
	assert_eq(sharp_stones.respawn_distance_x, -48.0, "Default X respawn distance should be -48 (3 tiles)")
	assert_eq(sharp_stones.respawn_distance_y, -80.0, "Default Y respawn distance should be -80 (5 tiles)")

func test_animated_sprite_reference_is_valid():
	# Verify the AnimatedSprite2D reference is set up
	assert_not_null(sharp_stones.animated_sprite, "AnimatedSprite2D reference should be valid")
	assert_is(sharp_stones.animated_sprite, AnimatedSprite2D, 
		"Referenced node should be AnimatedSprite2D")
