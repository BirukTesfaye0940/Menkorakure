extends Area2D

@onready var canvas_layer: Node = get_canvas_layer()
@onready var game_manager: Node = %GameManager
@onready var label: Label = canvas_layer.get_node("MarginContainer2/MessageLabel")
@onready var ores_collected_label: Label = canvas_layer.get_node("MarginContainer3/OresCollectedLabel")
@onready var cutscene: VideoStreamPlayer = canvas_layer.get_node("CutscenePlayer")  # Reference to the Video Player
#@onready var ores_collected_label: Label = canvas_layer.get_node("OresCollectedLabel")  # Get the label inside it

var player_in_area: bool = false

func get_canvas_layer() -> Node:
	var possible_paths = [
		"/root/LevelThreeTwo/CanvasLayer",
		"/root/Level/CanvasLayer"
	]
	
	for path in possible_paths:
		if has_node(path):
			return get_node(path)
	
	push_error("CanvasLayer not found! Make sure it's in one of the expected paths.")
	return null  # Returns null if not found

func _on_body_entered(_body: Node2D) -> void:
	player_in_area = true
	label.text = "Press Ctrl or E to collect an Ore"
	label.visible = true

func _on_body_exited(_body: Node2D) -> void:
	player_in_area = false
	label.visible = false

func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("collect_ore"):
		label.visible = false
		cutscene.visible = true
		cutscene.play()
		await cutscene.finished  # Wait for the cutscene to finish
		cutscene.visible = false  # Hide the video player after playback
		game_manager.add_point()
		ores_collected_label.text = "Mined: " + str(game_manager.ores_collected)  # Update UI
		queue_free()
