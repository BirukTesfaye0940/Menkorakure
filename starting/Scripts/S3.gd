extends TextureRect
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://starting/Scenes/S3L.tscn")
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://starting/Scenes/S3H.tscn")
	pass # Replace with function body.


func _on_button_5_pressed() -> void:
	get_tree().change_scene_to_file("res://starting/Scenes/S3S.tscn")
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
