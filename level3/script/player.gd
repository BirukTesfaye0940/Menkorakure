extends CharacterBody2D

const BASE_SPEED = 100.0
const BASE_RUN_SPEED = 160.0
const JUMP_VELOCITY = -350.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed_multiplier := 1.0  # Used for modifying speed externally

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	var is_running = Input.is_action_pressed("run")

	var current_speed: int = (BASE_RUN_SPEED if is_running else BASE_SPEED) * speed_multiplier

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()
