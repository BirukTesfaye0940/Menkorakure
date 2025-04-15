extends Node2D

@onready var player = $Player
@onready var CUTSCENE_1 = preload("res://scenes/cutscene_1.tscn")
func _ready() -> void:
	# Pause the game
	get_tree().paused = true
	# Start intro cutscene
	var intro_cutscene = CUTSCENE_1.instantiate()
	add_child(intro_cutscene)
