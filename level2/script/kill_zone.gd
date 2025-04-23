extends Area2D
@onready var timer = $Timer
@onready var fade_overlay_scene = preload("res://level2/scene/fade_overlay.tscn")
@onready var level_failed_scene = preload("res://level2/scene/game_over.tscn")
func _on_body_entered(body: Node2D) -> void:

	Engine.time_scale = 1.0
	body.get_node("CollisionShape2D").queue_free()
	timer.start()

func _on_timer_timeout() -> void:
	#get_tree().reload_current_scene()
	print("Player died!")
	# Fade out before showing LevelFailed
	var fade_overlay = fade_overlay_scene.instantiate()
	get_tree().root.add_child(fade_overlay)
	fade_overlay.fade_out(1.9, show_level_failed)



func show_level_failed() -> void:
	var level_failed = level_failed_scene.instantiate()
	get_tree().root.add_child(level_failed)
