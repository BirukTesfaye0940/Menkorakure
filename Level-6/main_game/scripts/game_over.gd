extends Control

func _ready() -> void:
	#$GameOverLabel.position = Vector2(576, 200)
	#$RestartButton.position = Vector2(476, 400)
	#$QuitButton.position = Vector2(476, 500)
	$RestartButton.pressed.connect(_on_restart_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)
	visible = false

func show_game_over() -> void:
	visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
