extends CanvasLayer

@onready var retry_button = $Panel/Button
@onready var menu_button = $Panel/Button2
@onready var exit_button = $Panel/Button3

func _ready() -> void:
	# Connect button signals
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	# Pause game
	#get_tree().paused = true

func _on_retry_pressed() -> void:
	#get_tree().paused = false
	#queue_free()
	get_tree().change_scene_to_file("res://Level1/scenes/game.tscn") 
	print("Retry button pressed")

func _on_menu_pressed() -> void:
	#get_tree().paused = false
	#var hud = get_tree().get_first_node_in_group("hud")
	#if hud:
		#hud.queue_free()
	#queue_free()
	get_tree().change_scene_to_file("res://starting/Scenes/S1.tscn")  # Adjust path
	print("Menu button pressed")

func _on_exit_pressed() -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.queue_free()
	queue_free()
	get_tree().quit()
	print("Exit button pressed")
