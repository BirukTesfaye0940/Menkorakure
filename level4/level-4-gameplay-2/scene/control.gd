extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("space"):
		get_tree().change_scene_to_file("res://level-4-gameplay-2/scene/game_play_2_level_4.tscn")
