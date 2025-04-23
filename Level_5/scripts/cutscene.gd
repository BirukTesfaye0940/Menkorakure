extends CanvasLayer

@onready var video_player = $VideoStreamPlayer
@onready var timer = $Timer
@onready var level_complete_scene = preload("res://Level_5/ui/level_complete.tscn")
@onready var fade_overlay_scene = preload("res://Level_5/scenes/fade_overlay_1.tscn")
var has_shown_level_complete: bool = false  # Prevent multiple calls

func _ready() -> void:
	print("Cutscene _ready() called")
	video_player.finished.connect(_on_video_finished)
	timer.timeout.connect(_on_timer_timeout)
	
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

func end_cutscene() -> void:
	if has_shown_level_complete:
		print("Level complete screen already shown, skipping end_cutscene")
		queue_free()  # Free the cutscene node if we've already shown the level complete screen
		return
	print("Endgame cutscene ended")
	get_tree().paused = false
	# Fade out before showing LevelComplete
	var fade_overlay = fade_overlay_scene.instantiate()
	get_tree().root.add_child(fade_overlay)
	fade_overlay.fade_out(1.5, _on_fade_out_complete)

func _on_fade_out_complete() -> void:
	show_level_complete()
	# Free the cutscene node after showing the level complete screen
	queue_free()

func show_level_complete() -> void:
	if has_shown_level_complete:
		print("Level complete screen already shown, skipping")
		return
	has_shown_level_complete = true
	print("Showing level complete screen")
	var level_complete = level_complete_scene.instantiate()
	get_tree().root.add_child(level_complete)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		print("Cutscene scene freed")
