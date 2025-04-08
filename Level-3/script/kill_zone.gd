extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You Died")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
	
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	Global.healthT = 4
	Global.current_gameplay_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")
	
