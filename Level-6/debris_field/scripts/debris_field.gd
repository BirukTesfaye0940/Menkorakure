extends Node2D

@export var RockScene: PackedScene = preload("res://debris_field/scenes/rock.tscn")
@export var IceScene: PackedScene = preload("res://debris_field/scenes/ice_collectible.tscn")
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")  
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height") 
@onready var spawn_timer: Timer = $Timer 

func _ready() -> void:
	if not spawn_timer.timeout.is_connected(_on_timer_timeout):
		spawn_timer.timeout.connect(_on_timer_timeout)
	spawn_timer.wait_time = randf_range(0.5, 1.5)
	spawn_timer.start()

func _on_timer_timeout() -> void:
	if randf() > 0.2:
		spawn_rock()
	else:
		spawn_ice()
	spawn_timer.wait_time = randf_range(0.5, 1.5)

func spawn_rock() -> void:
	var rock: RigidBody2D = RockScene.instantiate()
	rock.position = Vector2(screen_width + 50, randf_range(0, screen_height))
	rock.apply_central_impulse(Vector2(randf_range(-400, -200), randf_range(-100, 100)))
	rock.angular_velocity = randf_range(-2, 2)
	add_child(rock)

func spawn_ice() -> void:
	var ice: Area2D = IceScene.instantiate()
	ice.position = Vector2(screen_width + 50, randf_range(0, screen_height))
	add_child(ice)
