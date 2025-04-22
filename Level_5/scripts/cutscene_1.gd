extends CanvasLayer

@onready var video_player = $VideoStreamPlayer
@onready var timer = $Timer

func _ready() -> void:
	set_process_input(true)
	video_player.stream = preload("res://Level_5/assets/Level 5_Cut1.ogv") 
	
	video_player.process_mode = Node.PROCESS_MODE_ALWAYS
	timer.process_mode = Node.PROCESS_MODE_ALWAYS
	#video_player.playback_speed = 0.8  # Set speed to 0.8x
	video_player.position = Vector2.ZERO
	#video_player.size = get_viewport_rect().size
	# Connect signals
	video_player.finished.connect(_on_video_finished)
	timer.timeout.connect(_on_timer_timeout)
	# Start playback
	video_player.play()
	timer.start()
	print("Intro cutscene started ")
	
func _input(event: InputEvent) -> void:
	#print("Input event received: ", event.as_text())  # Debug all inputs
	if event.is_action_pressed("escap"):
		print("ESC pressed, skipping intro cutscene")
		end_cutscene()

func _on_video_finished() -> void:
	end_cutscene()

func _on_timer_timeout() -> void:
	if video_player.is_playing():
		video_player.stop()
	end_cutscene()

func end_cutscene() -> void:
	print("Intro cutscene ended")
	get_tree().paused = false  # Unpause the game
	queue_free()  # Remove this sceneextends Node
