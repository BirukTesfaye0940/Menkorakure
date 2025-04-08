extends CharacterBody2D

const SPEED = 100.0
const RUN_SPEED = 160.0  # Running speed (double the normal speed)
const JUMP_VELOCITY = -350.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Check if Shift is pressed for running
	var is_running = Input.is_action_pressed("run")

	# Adjust speed based on whether Shift is held down
	var current_speed :int
	if is_running: 
		current_speed = RUN_SPEED
	else:
		current_speed = SPEED
	#var current_speed = is_running ? RUN_SPEED : SPEED
	
	# Flip the sprite based on direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Apply movement speed
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()
