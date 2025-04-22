extends "res://addons/gut/test.gd"

var Spaceship = load("res://level5/scenes/spaceship.tscn")
var spaceship: Area2D
var test_player: CharacterBody2D

func before_each():
	spaceship = autofree(Spaceship.instantiate())
	test_player = autofree(CharacterBody2D.new())
	
	# Setup mock methods on player
	test_player.heal = func(_amount): pass
	test_player.refill_oxygen = func(_amount): pass
	test_player.set_in_safe_zone = func(_value): pass
	
	# Stub the methods to track calls
	stub(test_player, "heal").to_do_nothing()
	stub(test_player, "refill_oxygen").to_do_nothing()
	stub(test_player, "set_in_safe_zone").to_do_nothing()

func test_ready_sets_up_signal_connections():
	spaceship._ready()
	assert_connected(spaceship, spaceship, "body_entered", "_on_body_entered")
	assert_connected(spaceship, spaceship, "body_exited", "_on_body_exited")

func test_body_entered_heals_player():
	spaceship._on_body_entered(test_player)
	assert_called(test_player, "heal", [1000.0])
	assert_called(test_player, "refill_oxygen", [1000.0])

func test_body_entered_sets_safe_zone():
	spaceship._on_body_entered(test_player)
	assert_called(test_player, "set_in_safe_zone", [true])

func test_body_exited_unsets_safe_zone():
	spaceship._on_body_entered(test_player)
	spaceship._on_body_exited(test_player)
	assert_call_count(test_player, "set_in_safe_zone", 2)
	assert_called(test_player, "set_in_safe_zone", [false])

func test_non_player_body_does_not_trigger_effects():
	var static_body = autofree(StaticBody2D.new())
	spaceship._on_body_entered(static_body)
	assert_not_called(test_player, "heal")
	assert_not_called(test_player, "refill_oxygen")
	assert_not_called(test_player, "set_in_safe_zone")

func test_animated_sprite_reference_exists():
	assert_not_null(spaceship.animated_sprite)
	assert_is(spaceship.animated_sprite, AnimatedSprite2D)
