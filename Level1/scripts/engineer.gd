extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: Sprite2D = $Sprite2D  # Changed type to Sprite2D
var nearby_monk = null

func _physics_process(delta: float) -> void:
	# Removed animation logic since Sprite2D doesn't support animations
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	if nearby_monk and Input.is_action_just_pressed("interact"):
		nearby_monk.interact()

	move_and_slide()
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft  # This still works with Sprite2D
