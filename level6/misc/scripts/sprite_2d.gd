extends Sprite2D

@export var scroll_speed := 50.0

func _process(delta):
	region_rect.position.x += scroll_speed * delta
	if region_rect.position.x >= texture.get_width():
		region_rect.position.x = 0
