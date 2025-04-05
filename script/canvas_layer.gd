extends CanvasLayer

static var image = load("res://assets/sprites/rounded-rectangle.png")

func _ready() -> void:
	await get_tree().process_frame  # Wait for one frame to ensure nodes exist
	var container = get_node_or_null("MarginContainer/HBoxContainer")
	
	if container:
		for i in 4:
			var text_rect = TextureRect.new()
			text_rect.texture = image
			text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			text_rect.custom_minimum_size = Vector2(50, 50)
			container.add_child(text_rect)
	else:
		print("Error: HBoxContainer not found")

func set_health(amount):
	print("Setting health to:", amount)  # Debugging
	# Remove all existing children
	for child in $MarginContainer/HBoxContainer.get_children():
		child.queue_free()
	
	# Create new health boxes
	for i in range(amount):
		var text_rect = TextureRect.new()
		text_rect.texture = image
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		text_rect.custom_minimum_size = Vector2(50, 50)  # Set a proper size
		$MarginContainer/HBoxContainer.add_child(text_rect)
