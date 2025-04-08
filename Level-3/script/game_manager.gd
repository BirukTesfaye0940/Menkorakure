extends Node

@export var ores_collected := 0

func add_point():
	ores_collected += 1

	if ores_collected == 4:
		Global.healthT = 4

		var next_scene := "res://Scene/level_three_two.tscn"
		var level_complete_scene := "res://Scene/level_complete.tscn"

		# If this is the first time, store the current gameplay scene
		if Global.current_gameplay_scene == "":
			Global.current_gameplay_scene = get_tree().current_scene.scene_file_path
			print(Global.current_gameplay_scene)

		# If we're already in the second part (level_three_two), go to level complete
		if get_tree().current_scene.scene_file_path == next_scene:
			get_tree().change_scene_to_file(level_complete_scene)
		else:
			get_tree().change_scene_to_file(next_scene)
