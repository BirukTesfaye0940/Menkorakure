extends Node2D

@onready var timer: Timer = $Timer  # Reference to the Timer node
@onready var label: Label = $CanvasLayer/MarginContainer4/TimerLabel  # Reference to the UI label (modify the path if needed)

var time_left: int = 120  # 2 minutes in seconds

func _ready() -> void:
	timer.wait_time = 1.0  # Timer ticks every second
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_update_timer"))
	_update_label()

func _update_timer() -> void:
	time_left -= 1
	_update_label()
	
	if time_left <= 0:
		get_tree().reload_current_scene()  # Restart the scene

func _update_label() -> void:
	var minutes = time_left / 60
	var seconds = time_left % 60
	label.text = "Time Left: %02d:%02d" % [minutes, seconds]
