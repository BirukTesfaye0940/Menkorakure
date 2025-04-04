extends Node2D

var dragging = false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var clicked = get_global_mouse_position().distance_to(position) < 50
		if clicked:
			dragging = true
	elif event is InputEventMouseButton and not event.pressed:
		dragging = false

func _process(delta):
	if dragging:
		position = get_global_mouse_position()
