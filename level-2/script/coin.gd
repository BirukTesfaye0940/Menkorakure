extends Area2D

var  new_player = preload("res://player.tscn")
@onready var  animation_player = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	var new_player = body
	new_player.add_point()
	animation_player.play("pickup")
