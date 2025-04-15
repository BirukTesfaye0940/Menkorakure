extends Area2D
@onready var game_manager: Node = %GameManager

# Called when a body enters the Area2D
func _on_body_entered(body: Node) -> void:
	# Check if the entering body is the player
	if body is CharacterBody2D:  # Assuming your player is a CharacterBody2D
		
		body.add_item("Seferon", 10)  
		queue_free()
