extends CharacterBody2D

# Moon gravity is much weaker
const MOON_GRAVITY = Vector2(0, 50) # Feel free to tweak
const SPEED = 1000.0
const THRUST = -150.0 # Slight upward force when pressing 'up'

func _physics_process(delta: float) -> void:
	# Apply low gravity
	velocity += MOON_GRAVITY * delta

	# Main engine - allow upward thrust with a key (like space or up arrow)
	if Input.is_action_pressed("up"):
		velocity.y += THRUST * delta

	# Allow side control mid-air too
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	# Apply movement
	move_and_slide()
