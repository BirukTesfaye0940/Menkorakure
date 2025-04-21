# Defines the tile as a stationary physics body
extends StaticBody2D
# Variables to store the tile's texture and name
var tiletexture
var tilename
func _ready() -> void:
# Assign the stored texture to the tile's Sprite2D component
	$Sprite2D.texture=tiletexture
func _process(delta: float) -> void:
	pass
