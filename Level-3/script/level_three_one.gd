extends Node2D

@onready var timer: Timer = $Timer
@onready var label: Label = $CanvasLayer/MarginContainer4/TimerLabel
@onready var cutscene_player := $MarginContainer/CutScenePlayer
@onready var skip_button: Button = $MarginContainer/SkipButton

var time_left: int = 120

func _ready() -> void:
	timer.wait_time = 1.0
	timer.autostart = false
	timer.one_shot = false

	# Skip button setup
	skip_button.text = "Press enter to Skip"  # Ensure text is set
	skip_button.disabled = false
	skip_button.visible = true
	skip_button.mouse_filter = Control.MOUSE_FILTER_STOP  # Ensure it receives mouse input
	skip_button.focus_mode = Control.FOCUS_ALL  # Allow focus for input
	skip_button.z_index = 12  # Ensure button is on top
	skip_button.modulate = Color(1, 1, 1, 1)  # Ensure button is fully opaque

	# Connect signals
	if not cutscene_player.is_connected("finished", Callable(self, "_on_cutscene_finished")):
		cutscene_player.connect("finished", Callable(self, "_on_cutscene_finished"))

	if not skip_button.is_connected("pressed", Callable(self, "_on_skip_pressed")):
		skip_button.connect("pressed", Callable(self, "_on_skip_pressed"))
		print("Pressed signal connected")  # Debug signal connection

	# Debug input handling
	if not skip_button.is_connected("gui_input", Callable(self, "_on_button_gui_input")):
		skip_button.connect("gui_input", Callable(self, "_on_button_gui_input"))

	cutscene_player.play()
	_update_label()

func _input(event: InputEvent) -> void:
	# Check for Enter key press to trigger skip
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if skip_button.visible and not skip_button.disabled:
			print("Enter key pressed - triggering skip")
			_on_skip_pressed()

func _on_button_gui_input(event: InputEvent) -> void:
	# Debug to confirm input is received
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Left mouse button pressed on skip button")
		else:
			print("Left mouse button released on skip button")

func _on_skip_pressed() -> void:
	print("Skip button pressed - signal triggered")
	cutscene_player.stop()
	_start_gameplay()

func _on_cutscene_finished() -> void:
	_start_gameplay()

func _start_gameplay() -> void:
	cutscene_player.visible = false
	skip_button.visible = false  # Hide the skip button on gameplay start

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
