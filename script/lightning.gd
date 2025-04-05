extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	Global.healthT -= 1
	get_tree().call_group('CanvasLayer', 'set_health', Global.healthT)
	
	if Global.healthT <= 0:
		call_deferred("reload_scene")

func reload_scene() -> void:
	get_tree().reload_current_scene()  
