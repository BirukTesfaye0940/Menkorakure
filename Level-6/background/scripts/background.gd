extends Sprite2D

@export var scroll_speed: float = 150.0
var viewport_size: Vector2

func _ready() -> void:
	 
	viewport_size = get_viewport_rect().size
	# Set initial region to cover viewport
	region_rect = Rect2(0, 0, viewport_size.x, viewport_size.y)
	# Ensure the texture repeats seamlessly
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

func scroll_background(input_dir: Vector2, delta: float) -> void:
	# Scroll the background based on the player's input direction
	region_rect.position.x += input_dir.x * scroll_speed * delta
	region_rect.position.y += input_dir.y * scroll_speed * delta
	# Loop when reaching image edge
	if region_rect.position.x >= texture.get_width():
		region_rect.position.x -= texture.get_width()
	elif region_rect.position.x < 0:
		region_rect.position.x += texture.get_width()
	if region_rect.position.y >= texture.get_height():
		region_rect.position.y -= texture.get_height()
	elif region_rect.position.y < 0:
		region_rect.position.y += texture.get_height()
