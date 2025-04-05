# Rock.gd
extends Area2D

var speed: float  # Changed to float for smoother movement
var rotation_speed: float
var direction: Vector2  # More flexible movement direction

signal collision(rock_node)

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	# Load random sprite
	var path: String = "res://Assets/sprites/" + str(rng.randi_range(1, 3)) + ".png"
	var texture = load(path)
	$Sprite2D.texture = texture
	
	# Get screen width and set random position
	var screen_width = get_viewport().get_visible_rect().size.x
	position.x = rng.randf_range(0, screen_width)
	position.y = rng.randf_range(-150, -50)
	
	# Initialize movement properties
	speed = rng.randf_range(200.0, 400.0)
	rotation_speed = rng.randf_range(40.0, 100.0)
	
	# Add slight horizontal movement for more natural fall
	direction = Vector2(rng.randf_range(-0.2, 0.2), 1.0).normalized()

func _process(delta: float) -> void:
	# Move with direction vector
	position += direction * speed * delta
	rotation_degrees += rotation_speed * delta
	
	# Optional: Remove rock if it goes off-screen
	if position.y > get_viewport().get_visible_rect().size.y + 50:
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	print("Hit by Rock")
	collision.emit(self)
