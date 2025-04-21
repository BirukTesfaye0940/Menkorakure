extends Control

@onready var video_player: VideoStreamPlayer = $VideoPlayer

func _ready():
	# Connect the "finished" signal to transition to the gameplay scene
	video_player.finished.connect(_on_video_finished)
func _input(event):
	if event.is_action_pressed("jump"):  # "jump" is mapped to Space
		_on_video_finished()  # Skip the video and transition immediately
func _on_video_finished():
	# Transition to the gameplay scene after the video finishes
	get_tree().change_scene_to_file("res://Level1/scenes/game_play_1.tscn")
