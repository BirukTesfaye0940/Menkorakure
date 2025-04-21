extends Button

func _pressed() -> void:
	print("Quit button pressed")
	get_parent()._on_quit_pressed()  
