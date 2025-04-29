extends Area2D

@onready var closed_chest = $closed_chest
@onready var opened_chest = $opened_chest
@onready var game_manager = %GameManeger

var chest_opened = false

func _ready() -> void:
	closed_chest.visible = true
	opened_chest.visible = false

func _on_body_entered(body: Node2D) -> void:
	print("entered by : " , body.name)
	if body.name == "player" and not chest_opened:
		chest_opened = true
		open_chest()

func open_chest() -> void:
	closed_chest.visible = false
	opened_chest.visible = true
	game_manager.show_dialog()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://level2/scene/ring_puzzle.tscn")
