extends Control

func _ready():
	$PlayButton.pressed.connect(_on_play_button_pressed)
	$ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Level-5/scenes/game.tscn")

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Starting/Scenes/S3L.tscn")
