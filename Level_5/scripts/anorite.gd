extends Area2D
@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when a body enters the Area2D
func _on_body_entered(body: Node) -> void:
	# Check if the entering body is the player
	if body is CharacterBody2D:  # Assuming your player is a CharacterBody2D
		body.add_item("Anorite", 10) 
		game_manager.add_point()
		animation_player.play("pickup animation")
