extends Control

@onready var video_player = $VideoStreamPlayer
@onready var skip_button = $SkipButton

func _ready():
	video_player.play()
	video_player.finished.connect(_on_video_finished)

	
func _on_video_finished():
	get_tree().change_scene_to_file("res://level4/scenes/intro.tscn")


func _on_skip_button_pressed() -> void:
	video_player.stop()
	get_tree().change_scene_to_file("res://level4/scenes/intro.tscn")
