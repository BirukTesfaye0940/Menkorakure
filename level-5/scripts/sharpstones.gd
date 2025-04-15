extends Area2D

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Reference to your AnimatedSprite2D

@export var damage: float = 100.0
@export var respawn_distance_x: float = -48.0  # 3 tiles back (16px * 3 = 48px left)
@export var respawn_distance_y: float = -80.0  # 3 tiles back (16px * 3 = 48px left)

func _ready() -> void:
	# Ensure signals are connected
	if not is_connected("body_entered", _on_body_entered):
		connect("body_entered", _on_body_entered)
	if not timer.is_connected("timeout", _on_timer_timeout):
		timer.connect("timeout", _on_timer_timeout)


func _on_body_entered(body: Node) -> void:
	# Check if the body is the player (assuming CharacterBody2D)
	if body is CharacterBody2D:  # Or use body.name == "Player" or body.is_in_group("player")
		# Start the timer
		timer.start()

func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")  # Assumes player is in "player" group
	if player and player.has_method("take_damage"):
		player.take_damage(damage)  # Deal 100 damage
	# Restart the level
	# get_tree().reload_current_scene()
	# Respawn 3 tiles back
		var new_position = player.global_position
		new_position.x += respawn_distance_x  # Move left (negative for "back")
		new_position.y += respawn_distance_y  # Move 5 tiles Up 
		
		player.global_position = new_position
