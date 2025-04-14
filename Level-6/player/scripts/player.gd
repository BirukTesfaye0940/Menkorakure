extends CharacterBody2D

# Movement settings
@export var move_speed: float = 72.0
@export var screen_padding: float = 30.0
@export var bullet_scene: PackedScene = preload("res://player/scenes/bullet.tscn")
@export var fire_rate: float = 0.15
@export var bullet_spawn_distance: float = 50.0
@export var rock_damage_scale: float = 0.5
@export var ice_heal_amount: float = 1.0
var last_collision_time: float = 0.0
@export var collision_cooldown: float = 0.5

@onready var health_manager: HealthManager = $HealthManager
@onready var ship_sprite: Sprite2D = $ShipSprite
@onready var ice_detector: Area2D = $IceDetector

var can_shoot: bool = true
var shoot_timer: Timer
# Center of the screen (adjust based on your viewport size, e.g., 1152x720)
var screen_center: Vector2 = Vector2(576, 200)
# Maximum distance the player can move from the center
var max_distance_from_center: float = 330.0  # Adjust this to control how far the player can move

func _ready() -> void:
	add_to_group("player")
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	health_manager.health_changed.connect(_on_health_changed)
	health_manager.died.connect(_on_died)
	ice_detector.area_entered.connect(_on_ice_collected)
	# Set the player's initial position to the center
	global_position = screen_center

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * move_speed
	apply_screen_boundaries()
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision.get_collider())
	move_and_slide()

func apply_screen_boundaries() -> void:
	# Clamp the player's position to a small area around the center
	var min_pos = screen_center - Vector2(max_distance_from_center, max_distance_from_center)
	var max_pos = screen_center + Vector2(max_distance_from_center, max_distance_from_center)
	global_position = global_position.clamp(min_pos, max_pos)

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot() -> void:
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	var forward: Vector2 = Vector2(cos(rotation), sin(rotation))
	bullet.global_position = global_position + forward * bullet_spawn_distance
	bullet.direction = forward
	bullet.rotation = rotation
	get_parent().add_child(bullet)
	can_shoot = false
	shoot_timer.start(fire_rate)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_paste"):
		health_manager.apply_damage(health_manager.max_health)

func handle_collision(collider: Node) -> void:
	var current_time: float = Time.get_ticks_msec() / 1000.0
	if current_time - last_collision_time < collision_cooldown:
		return
	last_collision_time = current_time
	if collider.is_in_group("rocks"):
		handle_rock_collision(collider)

func handle_rock_collision(rock: Node) -> void:
	var size_ratio: float = rock.current_scale / rock.big_size
	var damage: float = (size_ratio / rock_damage_scale)
	health_manager.apply_damage(damage)
	var knockback_dir: Vector2 = (global_position - rock.global_position).normalized()
	velocity = knockback_dir * move_speed * 0.3

func _on_ice_collected(area: Area2D) -> void:
	if area.is_in_group("ice"):
		print("Yuppie! Ice collected.")
		handle_ice_collision(area)

func handle_ice_collision(ice: Node) -> void:
	health_manager.apply_heal(ice_heal_amount)
	ship_sprite.modulate = Color.GREEN
	await get_tree().create_timer(0.1).timeout
	ship_sprite.modulate = Color.WHITE
	ice.queue_free()

func _on_health_changed(current: float, maximum: float) -> void:
	if current < maximum:
		ship_sprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		ship_sprite.modulate = Color.WHITE
		health_manager.set_invulnerable(true, 1.0)

func _on_died() -> void:
	var explosion = preload("res://effects/scenes/explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
