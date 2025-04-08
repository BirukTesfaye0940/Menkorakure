extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var upgrade_ui = preload("res://scenes/upgrade_ui.tscn").instantiate()  


func _ready() -> void:
	# Connect signals
	if not is_connected("body_entered", _on_body_entered):
		connect("body_entered", _on_body_entered)
	if not is_connected("body_exited", _on_body_exited):
		connect("body_exited", _on_body_exited)
	get_tree().root.call_deferred("add_child", upgrade_ui)  # Add UI to scene tree			
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:  # Check if it's the player
		
		# Instantly refill health and oxygen to 100%
		if body.has_method("heal") and body.has_method("refill_oxygen"):
			body.heal(1000.0)  # Large value to ensure full health
			body.refill_oxygen(1000.0)  # Large value to ensure full oxygen
		# Set flag to prevent drain
		if body.has_method("set_in_safe_zone"):
			body.set_in_safe_zone(true)
			# Show upgrade UI
		upgrade_ui.set_player(body)
		upgrade_ui.show()

func _on_body_exited(body: Node) -> void:
	
	if body is CharacterBody2D:
		if body.has_method("set_in_safe_zone"):
			body.set_in_safe_zone(false)
	# Hide upgrade UI
		upgrade_ui.hide()
