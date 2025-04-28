extends CanvasLayer

var pause = false

func pause_play():
	pause = !pause
	$PauseMenu.visible = pause

func resume():
	pause_play()

func restart():
	get_tree().reload_current_scene()

func load_world():
	pass

func quit():
	get_tree().quit()

func _ready() -> void:
	# Make sure PauseMenu is hidden at start
	$PauseMenu.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('ui_cancel'):  # <- FIXED
		pause_play()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	restart()

func _on_world_map_pressed() -> void:
	load_world()

func _on_quit_pressed() -> void:
	quit()
