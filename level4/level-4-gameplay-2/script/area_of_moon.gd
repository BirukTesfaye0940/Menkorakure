extends Area2D

func _ready():
	pass

func _on_body_entered(body):
	if body.is_in_group("rocket"):
		if GlobalLevel4.rings_passed < 11:
			call_deferred("change_scene", "res://level4/level-4-gameplay-2/scene/control.tscn")
		else:
			call_deferred("change_scene", "res://level4/level-4-gameplay-2/scene/level_complete.tscn")

func change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
