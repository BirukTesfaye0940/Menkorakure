extends CanvasLayer

@onready var video_player = $VideoStreamPlayer
@onready var timer = $Timer

func _ready() -> void:
	print("Cutscene _ready() called")
	video_player.finished.connect(_on_video_finished)
	timer.timeout.connect(_on_timer_timeout)
	# Ensure visibility and position
	#video_player.position = Vector2.ZERO
	#video_player.size = get_viewport_rect().size  # Fill screen
	print("Video player position: ", video_player.position, " size: ", video_player.size)
	video_player.play()
	print("Video playing: ", video_player.is_playing())
	timer.start()

func _on_video_finished() -> void:
	print("Video finished")
	end_cutscene()

func _on_timer_timeout() -> void:
	print("Timer timeout")
	if video_player.is_playing():
		video_player.stop()
	end_cutscene()

func end_cutscene() -> void:
	print("Ending cutscene")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")  # Adjust path
