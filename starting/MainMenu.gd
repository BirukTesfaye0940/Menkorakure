extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_newGame_pressed() -> void:
	pass # Replace with function body.


func _on_Levels_pressed() -> void:
	get_tree().change_scene_to_file("res://starting/Scenes/S3L.tscn")
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://starting/Scenes/S3S.tscn")
	pass # Replace with function body.


func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://starting/Scenes/S3H.tscn")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
