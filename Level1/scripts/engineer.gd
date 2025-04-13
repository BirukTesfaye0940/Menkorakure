extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var nearby_monk = null  # To store a reference to the Monk when in range

func _physics_process(delta: float) -> void:
	# Animations
	if velocity.x > 1 || velocity.x < -1:
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2d.animation = "jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	# Interaction logic: Call the Monk's interact() function when "E" is pressed
	if nearby_monk and Input.is_action_just_pressed("interact"):  # "interact" mapped to "E"
		nearby_monk.interact()

	move_and_slide()
	# Flip the sprite based on movement direction
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
