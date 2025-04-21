extends Node2D

@onready var player: CharacterBody2D = $GameElements/Player
@onready var health_bar: Control = $GameElements/HealthBar
@onready var game_over: Control = $StartMenu/GameOver
@onready var game_start: Control = $StartMenu/GameStart

func _ready() -> void:
	# Set initial visibility for UI elements
	get_parent().get_tree().paused = true
	game_start.visible = true
	health_bar.visible = false
	if game_over:
		game_over.visible = false
	
	# Connect the start_game signal (ensure the GameStart node defines this signal)
	game_start.start_game.connect(_on_start_game)
	
	# Connect HealthManager signals if the node exists under Player.
	var health_manager: HealthManager = player.get_node("HealthManager")
	if health_manager:
		health_manager.health_changed.connect(health_bar.update_health)
		health_manager.died.connect(_on_player_died)
		health_bar.update_health(health_manager.current_health, health_manager.max_health)
	else:
		print("Error: HealthManager not found in Player")

func _on_start_game() -> void:
	game_start.visible = false
	health_bar.visible = true
	# Unpause the game elements by unpausing the entire scene tree.
	get_tree().paused = false

func _on_player_died() -> void:
	if game_over:
		game_over.show_game_over()
