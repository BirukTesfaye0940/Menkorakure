extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_id1_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/level_complete_L1.tscn")

func _on_id_3_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/game_over_L1.tscn")
	pass


func _on_id_4_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/game_over_L1.tscn")
	pass


func _on_id_6_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/game_over_L1.tscn")
	pass # Replace with function body..


func _on_id_7_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/game_over_L1.tscn")
	pass # Replace with function body.


func _on_id_8_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/game_over_L1.tscn")
	pass # Replace with function body.


func _on_id_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Level1/scenes/game_over_L1.tscn")
	pass # Replace with function body.
