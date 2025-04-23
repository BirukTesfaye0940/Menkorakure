extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://starting/Scenes/S3.tscn")
	pass # Replace with function body.


func _on_level1_pressed() -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/MainMenu.tscn")
	pass # Replace with function body.


func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Level_5/scenes/MainMenu1.tscn")
	pass


func _on_level_6_pressed() -> void: 
	get_tree().change_scene_to_file("res://level6/main_game/scenes/MainMenu.tscn")
	pass # Replace with function body.


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://level3/Scene/level_three_one.tscn")
	


func _on_level2_pressed() -> void:
	get_tree().change_scene_to_file("res://level2/scene/background.tscn")
	pass # Replace with function body.


func _on_level_4_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://level4/scenes/cut_scene.tscn")
	
