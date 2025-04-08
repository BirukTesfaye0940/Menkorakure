extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	Global.healthT -= 1
	get_tree().call_group('CanvasLayer', 'set_health', Global.healthT)
	
	if Global.healthT <= 0:
		call_deferred("reload_scene")

func reload_scene() -> void:
	Global.healthT = 4
	Global.current_gameplay_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")  
