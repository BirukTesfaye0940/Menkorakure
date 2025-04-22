extends CanvasLayer

@onready var video_player = $VideoStreamPlayer
@onready var timer = $Timer
@onready var level_complete_scene = preload("res://Level_5/ui/level_complete.tscn")
@onready var fade_overlay_scene = preload("res://Level_5/scenes/fade_overlay_1.tscn")
func _ready() -> void:
	print("Cutscene _ready() called")
	video_player.finished.connect(_on_video_finished)
	timer.timeout.connect(_on_timer_timeout)
	# Ensure visibility and position
	#video_player.position = Vector2.ZERO
	#video_player.size = get_viewport_rect().size  # Fill screen
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.queue_free()
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

#func end_cutscene() -> void:
	#print("Endgame cutscene ended")
	#get_tree().paused = false
	#var level_complete = level_complete_scene.instantiate()
	#get_tree().root.add_child(level_complete)
	#queue_free()
func end_cutscene() -> void:
	print("Endgame cutscene ended")
	get_tree().paused = false
	# Fade out before showing LevelComplete
	var fade_overlay = fade_overlay_scene.instantiate()
	get_tree().root.add_child(fade_overlay)
	fade_overlay.fade_out(1.5, show_level_complete)
	#queue_free()

func show_level_complete() -> void:
	var level_complete = level_complete_scene.instantiate()
	get_tree().root.add_child(level_complete)
