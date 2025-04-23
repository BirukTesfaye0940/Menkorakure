extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Spaceship":
		print(" Ring touched by:", body.name)
		get_tree().current_scene.call("on_ring_collected", self)
