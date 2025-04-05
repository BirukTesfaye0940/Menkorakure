# Main scene
extends Node2D

var rock_scene: PackedScene = preload("res://Scene/rock.tscn")  # Use preload for better performance
@onready var timer: Timer = $LevelTimer  # Reference to the Timer node
@onready var label: Label = $CanvasLayer/MarginContainer4/TimerLabel  # Reference to the UI label (modify the path if needed)

var time_left: int = 120  # 2 minutes in seconds
func _ready():
	timer.wait_time = 1.0  # Timer ticks every second
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_update_timer"))
	_update_label()

func _on_timer_timeout() -> void:
	var rock = rock_scene.instantiate()
	add_child(rock)  # Add to main node instead of $Rock (unless $Rock is meant to be a container)
	rock.collision.connect(_on_rock_collision)

func _on_rock_collision(rock_node):  # Receive the rock node
	Global.healthT -= 1
	get_tree().call_group('CanvasLayer', 'set_health', Global.healthT)
	rock_node.queue_free()  # Remove the rock that collided
	if Global.healthT <= 0:
		get_tree().reload_current_scene()
		


func _update_timer() -> void:
	time_left -= 1
	_update_label()
	
	if time_left <= 0:
		get_tree().reload_current_scene()  # Restart the scene

func _update_label() -> void:
	var minutes = time_left / 60
	var seconds = time_left % 60
	label.text = "Time Left: %02d:%02d" % [minutes, seconds]
