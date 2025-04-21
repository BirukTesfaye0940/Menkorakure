extends Node2D
@export var move_distance := 100.0
@export var move_time := 1.0

func _ready():
	var start_pos = position
	var end_pos = position + Vector2(0, move_distance)

	var tween = get_tree().create_tween()
	tween.set_loops()  # infinite loop

	tween.tween_property(self, "position", end_pos, move_time).as_relative()
	tween.tween_property(self, "position", start_pos, move_time).as_relative()
