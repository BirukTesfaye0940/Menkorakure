extends Node2D

@onready var cutscene_player: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	cutscene_player.finished.connect(_on_cutscene_finished)

func _on_cutscene_finished() -> void:
	# Transition back to the main game scene
	print("mama oooooooh")
	get_tree().change_scene_to_file("res://starting/Scenes/S1.tscn")
