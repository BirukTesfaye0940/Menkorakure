extends Node

var player_scene = preload("res://level6/player/scenes/player.tscn")
var bullet_scene = preload("res://level6/player/scenes/bullet.tscn")
var explosion_scene = preload("res://level6/effects/scenes/explosion.tscn")
var player = null
var health_manager = 0.0
var ship_sprite = null
var ice_detector = null
var results = {}
var test_count = 0
var passed_count = 0

func _ready():
	# Instantiate player scene
	player = player_scene.instantiate()
	health_manager = player.get_node("HealthManager")
	ship_sprite = player.get_node("ShipSprite")
	ice_detector = player.get_node("IceDetector")
	add_child(player)
	
	# Initialize HealthManager mock
	# TODO: Confirm HealthManager properties and methods (e.g., health, max_health, apply_damage, apply_heal)
	# If HealthManager is a custom script, set its path below or adjust properties
	health_manager = 100.0
	health_manager = 100.0
	# Mock methods if not defined in HealthManager
	if not health_manager.has_method("apply_damage"):
		health_manager.apply_damage = func(amount): health_manager.health -= amount
	if not health_manager.has_method("apply_heal"):
		health_manager.apply_heal = func(amount): health_manager.health = min(health_manager.health + amount, health_manager.max_health)
	
	# Run tests
	run_tests()
	
	# Print summary
	print("\nTest Summary: %d/%d tests passed" % [passed_count, test_count])
	for test_name in results:
		print("%s: %s" % [test_name, results[test_name]])
	
	# Free player to avoid memory leaks
	player.queue_free()

func run_tests():
	# Test 1: Movement
	test_movement()
	
	# Test 2: Shooting
	test_shooting()
	
	# Test 3: Rock Collision
	test_rock_collision()
	
	# Test 4: Ice Collection
	test_ice_collection()
	
	# Test 5: Death
	test_death()
	
	# Edge Case: Shooting During Cooldown
	test_shooting_during_cooldown()

func test_movement():
	test_count += 1
	var test_name = "Movement"
	
	# Simulate moving up
	Input.action_press("ui_up")
	player._physics_process(1.0)
	var expected_velocity = Vector2(0, -72)
	var velocity_pass = player.velocity == expected_velocity
	print("Test 1: %s - Velocity check" % test_name)
	print("  Expected velocity: %s" % str(expected_velocity))
	print("  Actual velocity: %s" % str(player.velocity))
	
	# Check position clamping
	player.global_position = Vector2(1000, 1000)
	player.apply_screen_boundaries()
	var expected_position = Vector2(576, 200) + Vector2(330, 330)
	# TODO: Confirm viewport size (1152x720 assumed) and screen_center (576, 200)
	var position_pass = player.global_position == expected_position
	print("  Expected position: %s" % str(expected_position))
	print("  Actual position: %s" % str(player.global_position))
	
	# Log result
	var passed = velocity_pass and position_pass
	results[test_name] = "Pass" if passed else "Fail"
	if passed:
		passed_count += 1
		print("Test 1: %s - Pass" % test_name)
	else:
		print("Test 1: %s - Fail" % test_name)
	assert(passed, "Movement test failed: Check velocity or position clamping")

func test_shooting():
	test_count += 1
	var test_name = "Shooting"
	
	# Simulate shooting
	player.shoot()
	var children = get_parent().get_children()
	var bullet = null
	for child in children:
		if child != player and child.is_class("Node2D"):  # TODO: Replace with actual bullet node type (e.g., Area2D)
			bullet = child
			break
	var bullet_pass = bullet != null
	var position_pass = false
	var direction_pass = false
	if bullet:
		var forward = Vector2(cos(player.rotation), sin(player.rotation))
		var expected_position = player.global_position + forward * 50.0
		position_pass = bullet.global_position == expected_position
		direction_pass = bullet.direction == forward if bullet.get("direction") else false
		# TODO: Confirm bullet.direction property exists in bullet.tscn script
		print("Test 2: %s - Bullet check" % test_name)
		print("  Expected position: %s" % str(expected_position))
		print("  Actual position: %s" % str(bullet.global_position))
		print("  Expected direction: %s" % str(forward))
		print("  Actual direction: %s" % str(bullet.direction if bullet.get("direction") else "N/A"))
	var cooldown_pass = !player.can_shoot and player.shoot_timer.time_left > 0
	print("  can_shoot: %s (expected: false)" % str(player.can_shoot))
	print("  shoot_timer.time_left: %s (expected: > 0)" % str(player.shoot_timer.time_left))
	
	# Log result
	var passed = bullet_pass and position_pass and direction_pass and cooldown_pass
	results[test_name] = "Pass" if passed else "Fail"
	if passed:
		passed_count += 1
		print("Test 2: %s - Pass" % test_name)
	else:
		print("Test 2: %s - Fail" % test_name)
	assert(passed, "Shooting test failed: Check bullet instantiation or cooldown")

func test_rock_collision():
	test_count += 1
	var test_name = "Rock Collision"
	
	# Mock rock
	var rock = Node2D.new()
	rock.add_to_group("rocks")
	rock.global_position = Vector2(500, 200)
	rock.current_scale = 2.0
	rock.big_size = 4.0
	
	# Simulate collision
	var initial_health = health_manager.health
	player.handle_rock_collision(rock)
	var expected_damage = (2.0 / 4.0) / 0.5  # size_ratio / rock_damage_scale
	var health_pass = health_manager.health == initial_health - expected_damage
	print("Test 3: %s - Health check" % test_name)
	print("  Expected health: %s" % str(initial_health - expected_damage))
	print("  Actual health: %s" % str(health_manager.health))
	
	var knockback_dir = (player.global_position - rock.global_position).normalized()
	var expected_velocity = knockback_dir * 72 * 0.3
	var velocity_pass = player.velocity == expected_velocity
	print("  Expected velocity: %s" % str(expected_velocity))
	print("  Actual velocity: %s" % str(player.velocity))
	
	var time_pass = player.last_collision_time > 0
	print("  last_collision_time: %s (expected: > 0)" % str(player.last_collision_time))
	
	# Log result
	var passed = health_pass and velocity_pass and time_pass
	results[test_name] = "Pass" if passed else "Fail"
	if passed:
		passed_count += 1
		print("Test 3: %s - Pass" % test_name)
	else:
		print("Test 3: %s - Fail" % test_name)
	assert(passed, "Rock collision test failed: Check health, velocity, or collision time")
	rock.queue_free()

func test_ice_collection():
	test_count += 1
	var test_name = "Ice Collection"
	
	# Mock ice
	var ice = Area2D.new()
	ice.add_to_group("ice")
	
	# Simulate ice collection
	var initial_health = health_manager.health
	player._on_ice_collected(ice)
	var health_pass = health_manager.health == initial_health + 1.0
	print("Test 4: %s - Health check" % test_name)
	print("  Expected health: %s" % str(initial_health + 1.0))
	print("  Actual health: %s" % str(health_manager.health))
	
	var modulate_pass = ship_sprite.modulate == Color.GREEN
	print("  Sprite modulate: %s (expected: Color.GREEN)" % str(ship_sprite.modulate))
	
	var freed_pass = ice.is_queued_for_deletion()
	print("  Ice freed: %s (expected: true)" % str(freed_pass))
	
	# Log result
	var passed = health_pass and modulate_pass and freed_pass
	results[test_name] = "Pass" if passed else "Fail"
	if passed:
		passed_count += 1
		print("Test 4: %s - Pass" % test_name)
	else:
		print("Test 4: %s - Fail" % test_name)
	assert(passed, "Ice collection test failed: Check health, sprite, or ice freeing")
	ice.queue_free()

func test_death():
	test_count += 1
	var test_name = "Death"
	
	# Simulate death
	health_manager.health = 0
	player._on_died()
	var children = get_parent().get_children()
	var explosion = null
	for child in children:
		if child != player and child.is_class("Node2D"):  # TODO: Replace with actual explosion node type (e.g., AnimatedSprite2D)
			explosion = child
			break
	var explosion_pass = explosion != null
	var position_pass = explosion.global_position == player.global_position if explosion else false
	print("Test 5: %s - Explosion check" % test_name)
	print("  Explosion instantiated: %s" % str(explosion_pass))
	print("  Expected position: %s" % str(player.global_position))
	print("  Actual position: %s" % str(explosion.global_position if explosion else "N/A"))
	
	var deletion_pass = player.is_queued_for_deletion()
	print("  Player queued for deletion: %s" % str(deletion_pass))
	
	# Log result
	var passed = explosion_pass and position_pass and deletion_pass
	results[test_name] = "Pass" if passed else "Fail"
	if passed:
		passed_count += 1
		print("Test 5: %s - Pass" % test_name)
	else:
		print("Test 5: %s - Fail" % test_name)
	assert(passed, "Death test failed: Check explosion or player deletion")

func test_shooting_during_cooldown():
	test_count += 1
	var test_name = "Shooting During Cooldown"
	
	# Simulate shooting during cooldown
	player.can_shoot = false
	player.shoot()
	var children = get_parent().get_children()
	var bullet_count = 0
	for child in children:
		if child != player and child.is_class("Node2D"):  # TODO: Replace with actual bullet node type
			bullet_count += 1
	var no_bullet_pass = bullet_count == 0
	print("Test 6: %s - No bullet check" % test_name)
	print("  Bullet count: %s (expected: 0)" % str(bullet_count))
	
	# Log result
	var passed = no_bullet_pass
	results[test_name] = "Pass" if passed else "Fail"
	if passed:
		passed_count += 1
		print("Test 6: %s - Pass" % test_name)
	else:
		print("Test 6: %s - Fail" % test_name)
	assert(passed, "Shooting during cooldown test failed: Check can_shoot logic")
