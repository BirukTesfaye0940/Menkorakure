extends Node

@export var ores_collected := 0

func add_point():
	ores_collected  += 1
	if ores_collected == 4:
		get_tree().change_scene_to_file("res://Scene/level_three_two.tscn")
