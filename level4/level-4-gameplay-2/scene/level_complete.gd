extends Control

@onready var video_stream_player: VideoStreamPlayer = $MarginContainer/VideoStreamPlayer

func _ready():
	# Correct connect syntax in Godot 4
	video_stream_player.finished.connect(_on_video_finished)

func _on_video_finished():
	call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://Level_5/scenes/game.tscn")
