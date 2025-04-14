extends RigidBody2D

@export var min_size: float = 0.2
@export var split_scale_factor: float = 0.6
var big_size: float = 0.8
@export var initial_scale: float = 0.8
@export var move_speed: Vector2 = Vector2(-500, 0)
@export var random_impulse: Vector2 = Vector2(100, 100)
var current_scale: float = 1.0

func _ready() -> void:
	$Sprite2D.texture = preload("res://debris_field/assets/rocks/rock.png")
	gravity_scale = 0
	freeze = true
	set_rock_scale(initial_scale)
	var movement: Vector2 = Vector2(
		move_speed.x + randf_range(-random_impulse.x, random_impulse.x),
		move_speed.y + randf_range(-random_impulse.y, random_impulse.y)
	)
	linear_velocity = movement
	angular_velocity = randf_range(-2, 2)
	freeze = false

func _process(delta: float) -> void:
	if position.x < -100:
		queue_free()

func set_rock_scale(new_scale: float) -> void:
	current_scale = new_scale
	var scale_vec: Vector2 = Vector2(current_scale, current_scale)
	$Sprite2D.scale = scale_vec
	$CollisionShape2D.scale = scale_vec
	mass = 1.0 / current_scale

func destroy() -> void:
	if current_scale * split_scale_factor > min_size:
		split()
	else:
		var explosion: Node2D = preload("res://effects/scenes/explosion.tscn").instantiate()
		explosion.position = position
		get_parent().add_child(explosion)
	queue_free()

func split() -> void:
	for i in range(2):
		var small_rock: RigidBody2D = load("res://debris_field/scenes/rock.tscn").instantiate()
		var new_scale: float = current_scale * split_scale_factor
		small_rock.initial_scale = new_scale
		var offset: Vector2 = Vector2(randf_range(-30, 30), randf_range(-30, 30))
		small_rock.position = position + offset
		get_parent().add_child(small_rock)
		var force_dir: Vector2 = Vector2(randf_range(-1, 1), randf_range(-0.5, 1)).normalized()
		var force_magnitude: float = 150 * (1.0 + (1.0 - new_scale))
		small_rock.apply_central_impulse(force_dir * force_magnitude)
		small_rock.angular_velocity = randf_range(-3, 3)
