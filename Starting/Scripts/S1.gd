extends Node2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.play()
	video_stream_player.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_video_stream_player_finished() -> void:
	audio_stream_player_2d.stop()
	get_tree().change_scene_to_file("res://Starting/Scenes/S3.tscn")
	pass # Replace with function body.
