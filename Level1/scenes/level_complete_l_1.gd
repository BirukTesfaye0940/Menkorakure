extends CanvasLayer

@onready var next_level_button = $Panel/Button
@onready var retry_button = $Panel/Button3
@onready var exit_button = $Panel/Button2
func _ready() -> void:
	# Connect button signals
	print(55)
	next_level_button.pressed.connect(_on_next_level_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	# Pause game to focus on UI
	#get_tree().paused = true


func _on_next_level_pressed() -> void:
	print(11)
	#get_tree().paused = false
	## Remove HUD before transitioning
	#var hud = get_tree().get_first_node_in_group("hud")
	#if hud:
		#hud.queue_free()
	#queue_free()
	#set_physics_process(true)
	get_tree().change_scene_to_file("res://Level1/scenes/main.tscn") 
	print("Next Level button pressed")

func _on_retry_pressed() -> void:
	#get_tree().paused = false
	#queue_free()
	get_tree().change_scene_to_file("res://Level1/scenes/game.tscn") 
	print("Retry button pressed")

func _on_exit_pressed() -> void:
	print(22)
	# Remove HUD before exiting
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.queue_free()
	queue_free()
	get_tree().quit()
	print("Exit button pressed")
