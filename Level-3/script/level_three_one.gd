extends Node2D

@onready var timer: Timer = $Timer
@onready var label: Label = $CanvasLayer/MarginContainer4/TimerLabel
@onready var cutscene_player := $MarginContainer/CutScenePlayer
@onready var skip_button: Button = $CanvasLayer/MarginContainer5/SkipButton

var time_left: int = 120

func _ready() -> void:
	timer.wait_time = 1.0
	timer.autostart = false
	timer.one_shot = false
	# Do NOT connect the timer here anymore
	
	cutscene_player.play()
	cutscene_player.connect("finished", Callable(self, "_on_cutscene_finished"))

	skip_button.show()
	skip_button.connect("pressed", Callable(self, "_on_skip_pressed"))

	_update_label()  # This is okay to show the initial time

func _on_cutscene_finished() -> void:
	_start_gameplay()

func _on_skip_pressed() -> void:
	cutscene_player.stop()
	_start_gameplay()

func _start_gameplay() -> void:
	cutscene_player.visible = false
	skip_button.hide()

	if not timer.is_connected("timeout", Callable(self, "_update_timer")):
		timer.connect("timeout", Callable(self, "_update_timer"))
	
	timer.start()


func _update_timer() -> void:
	time_left -= 1
	_update_label()
	
	if time_left <= 0:
		get_tree().reload_current_scene()

func _update_label() -> void:
	var minutes = time_left / 60
	var seconds = time_left % 60
	label.text = "Time Left: %02d:%02d" % [minutes, seconds]
