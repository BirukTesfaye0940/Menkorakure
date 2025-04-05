extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
var score = 0
@onready var label = $Label
func add_point():
	score +=1
	label.text = "You collected" + " " + str(score) + " " + "coins."

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("new_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left","move_right")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
		
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("new_idle")
		else:
			animated_sprite.play("new_run")
	else:
		animated_sprite.play("new_jump")
		
	if direction:
		velocity.x = direction*SPEED
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)

	move_and_slide()
