extends CharacterBody2D

@export var speed = 300    # Speed of movement
@export var jump_force = -500  # Force applied when jumping
@export var gravity = 100   # Gravity applied over time
@export var final_jump_height = -1


 # Target Y position for jump

var is_jumping = true  # Initially true to start with a jump
var player_can_move = false  # Control movement after jump lands

@onready var chest = get_parent().get_node("chest") 
 # Reference to the chest in the scene

func _physics_process(delta):
	# Apply gravity while falling
	if is_jumping:
		velocity.y += gravity * delta

		# Check if player reached the final jump height
		if position.y >= final_jump_height:
			velocity.y = 0  # Stop falling
			is_jumping = false
			player_can_move = true  # Allow movement

	elif player_can_move:
		# Handle left and right movement
		velocity.y = 0
		velocity.x = 0
		if Input.is_action_pressed("ui_right"):
			velocity.x = speed
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -speed
		elif Input.is_action_pressed("ui_up"):
			velocity.y = -speed
		elif Input.is_action_pressed("ui_down"):
			velocity.y = speed
		else:
			velocity.x = 0  # Stop moving if no key is pressed

	# Move the player
	move_and_slide()

	# Check for chest interaction
	if chest and position.distance_to(chest.global_position) < 100:
		print("Player is near the chest! Press [E] to open.")
		if Input.is_action_just_pressed("ui_accept"):  # Assuming "ui_accept" is mapped to the interact key
			chest.open_chest()
			
		
# this code is need some refactoring 
#extends CharacterBody2D

#@export var speed = 300.0    # Speed of movement
##@export var jump_force = -500  # Force applied when jumping
#@export var jump_velocity = -300.0
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")   # Gravity applied over time
#@export var final_jump_height = 100
#@onready var animated_sprite = $AnimatedSprite2D
#
 ## Target Y position for jump
#
#var is_jumping = true  # Initially true to start with a jump
#var player_can_move = false  # Control movement after jump lands
#
#@onready var chest = get_parent().get_node("chest") 
 ## Reference to the chest in the scene
#
#func _physics_process(delta):
	## Apply gravity while falling
	#if not is_on_floor():
		#velocity.y += gravity * delta
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = jump_velocity
	#var direction = Input.get_axis("move_left","move_right")
	#if direction > 0:
		#animated_sprite.flip_h = false
	#elif direction < 0:
		#animated_sprite.flip_h = true
		#
		#
	#if is_on_floor():
		#if direction == 0:
			#animated_sprite.play("idle")
		#else:
			#animated_sprite.play("run")
	#else:
		#animated_sprite.play("jump")
		#
	#if direction:
		#velocity.x = direction*speed
	#elif Input.is_action_pressed("ui_up"):
		#velocity.y = -speed
	#elif Input.is_action_pressed("ui_down"):
		#velocity.y = speed
	#else:
		#velocity.x = move_toward(velocity.x,0,speed)
	##Check if player reached the final jump height
	#if position.y >= final_jump_height:
		#velocity.y = 0  # Stop falling
		#is_jumping = false
		#player_can_move = true  # Allow movement
	#
#
	#move_and_slide()
	
	
	  # Reset gravity effect




	#elif player_can_move:
		## Handle left and right movement
		#velocity.y = 0
		#velocity.x = 0
		#if Input.is_action_pressed("ui_right"):
			#velocity.x = speed
		#elif Input.is_action_pressed("ui_left"):
			#velocity.x = -speed
		#elif Input.is_action_pressed("ui_up"):
			#velocity.y = -speed
		#elif Input.is_action_pressed("ui_down"):
			#velocity.y = speed
		#else:
			#velocity.x = 0  # Stop moving if no key is pressed

	# Move the player
	

	## Check for chest interaction
	#if chest and position.distance_to(chest.global_position) < 100:
		#print("Player is near the chest! Press [E] to open.")
		#if Input.is_action_just_pressed("ui_accept"):  # Assuming "ui_accept" is mapped to the interact key
			#chest.open_chest()
