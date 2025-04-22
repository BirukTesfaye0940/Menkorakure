extends Node2D

@onready var player = $Player
@onready var CUTSCENE_1 = preload("res://Level_5/scenes/cutscene_1.tscn")
@onready var objective_panel_scene = preload("res://Level_5/scenes/objective_panel.tscn")
@onready var hud_scene = preload("res://Level_5/scenes/hud.tscn")

var hud_instance: Node
func _ready() -> void:
	# Instantiate and add HUD
	hud_instance = hud_scene.instantiate()
	hud_instance.add_to_group("hud")
	add_child(hud_instance)
	await get_tree().process_frame
	await get_tree().create_timer(0.1).timeout
	# Pause the game
	get_tree().paused = true
	# Start intro cutscene
	 
	
	
	var intro_cutscene = CUTSCENE_1.instantiate()
	add_child(intro_cutscene)
	# Show objective panel after intro cutscene
	intro_cutscene.connect("tree_exited", _on_intro_cutscene_exited)

func _on_intro_cutscene_exited() -> void:
	var objective_panel = objective_panel_scene.instantiate()
	get_tree().root.add_child(objective_panel)
	objective_panel.show_objective(player.global_position)

#func _process(delta: float) -> void:
	#print("FPS: ", Engine.get_frames_per_second())
