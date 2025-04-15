extends Button

func _pressed() -> void:
	print("Play button pressed")
	get_parent()._on_play_pressed()  
