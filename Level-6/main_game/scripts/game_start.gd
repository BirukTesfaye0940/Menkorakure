extends Control

signal start_game

func _ready() -> void:
	#$TitleLabel.position = Vector2(576, 200)
	#$PlayButton.position = Vector2(576, 400)
	#$QuitButton.position = Vector2(576, 500)
	$PlayButton.focus_mode = FOCUS_ALL
	$PlayButton.grab_focus()

func _on_play_pressed() -> void:
	emit_signal("start_game")

func _on_quit_pressed() -> void:
	get_tree().quit()
