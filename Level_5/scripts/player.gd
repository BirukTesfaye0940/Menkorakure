extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite = $AnimatedSprite2D

@onready var level_failed_scene = preload("res://Level_5/ui/game_over.tscn")

#@onready var anorite_label = get_node("/root/Hud/AnoriteLabel")
#@onready var seferon_label = get_node("/root/Hud/SeferonLabel")
#@onready var oxygen_bar = get_node("/root/Hud/OxygenBar")
#@onready var health_bar = get_node("/root/Hud/HealthBar")
var health_bar: Node = null
var oxygen_bar: Node = null
var anorite_label: Node = null
var seferon_label: Node = null
var hud_initialized: bool = false
var pause_menu: CanvasLayer = null
# Health variables 
@export var max_health: float = 250.0
var current_health: float = max_health
#@onready var health_bar = $HealthBar

#oxygen variable
@export var max_oxygen: float = 100.0  # Max oxygen capacity
var current_oxygen: float = max_oxygen  # Current oxygen level
@export var oxygen_drain_rate: float = 0.8  # Oxygen lost per second
@export var oxygen_jump_cost: float = 1.9  # Oxygen lost per jump
#@onready var oxygen_bar = $OxygenBar  # Reference to oxygen bar UI
#@onready var oxygen_bar: ProgressBar = $OxygenBar



# New flags for notifications
var shown_50_percent_warning: bool = false
var shown_10_percent_warning: bool = false
# Preload popup scene
@onready var notification_popup_scene = preload("res://Level_5/scenes/notification.tscn")
@onready var fade_overlay_scene = preload("res://Level_5/scenes/fade_overlay.tscn")
# Safe zone flag
var in_safe_zone: bool = false

# Inventory
var inventory: Dictionary = {
	"Anorite": 1000,  
	"Seferon": 1000   # Starting with 0
}

# Dust storm variables
var in_dust_storm: bool = false
var storm_oxygen_drain: float = 8.0
# Add flag to prevent multiple die() calls
var is_dead: bool = false

func _ready() -> void:
	add_to_group("player")
	initialize_pause_menu()
	# Initial attempt to find HUD nodes
	_initialize_hud_nodes()
	if hud_initialized:
		update_health_bar()
		update_oxygen_bar()
		update_inventory_ui()
func _physics_process(delta: float):
	
	if Input.is_action_just_pressed("pause"):  # "P" key
		toggle_pause()
	if get_tree().paused:
		return
	if not hud_initialized:
		_initialize_hud_nodes()
		if hud_initialized:
			update_health_bar()
			update_oxygen_bar()
			update_inventory_ui()
	# Stop processing if already dead
	if is_dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if not in_safe_zone:
			take_oxygen(oxygen_jump_cost)
			
	# Get the input direction and handle the movement/deceleration.
	
	# get the input diection:-1,0,1
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	 #play animation
	if direction == 0:
		animated_sprite.play("still")
	else:
		animated_sprite.play("idle")
	
	
	
	#apply the movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not in_safe_zone:
		take_oxygen(oxygen_drain_rate * delta)
		
		# Additional storm drain
	if in_dust_storm:
		take_oxygen(storm_oxygen_drain * delta)
	move_and_slide()
	check_oxygen_warnings()
	
func initialize_pause_menu() -> void:
	pause_menu = preload("res://Level_5/scenes/pause.tscn").instantiate()
	add_child(pause_menu)
	pause_menu.visible = false
	var resume_button = pause_menu.get_node_or_null("Panel/Button")
	var restart_button = pause_menu.get_node_or_null("Panel/Button2")
	var menu_button = pause_menu.get_node_or_null("Panel/Button3")
	if resume_button and restart_button and menu_button:
		resume_button.pressed.connect(_on_resume_button_pressed)
		restart_button.pressed.connect(_on_restart_button_pressed)
		menu_button.pressed.connect(_on_menu_button_pressed)
	else:
		push_error("One or more buttons not found in Pause.tscn. Check the node structure.")

# Health function
func take_damage(amount: float) -> void:
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	update_health_bar()
	if current_health <= 0:
		die()

func heal(amount: float) -> void:
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	update_health_bar()

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = (current_health / max_health) * 100
	else:
		print("Oxygen bar not available")
#func die() -> void:
	#if is_queued_for_deletion():
		#print("Player already queued for deletion")
		#return
	#if is_dead:
		#print("Player already marked as dead, skipping die()")
		#return
	#is_dead = true
	#set_physics_process(false)  # Stop physics processing
	#print("Player died!")
	#var level_failed = level_failed_scene.instantiate()
	#get_tree().root.add_child(level_failed)
func die() -> void:
	if is_queued_for_deletion():
		print("Player already queued for deletion")
		return
	if is_dead:
		print("Player already marked as dead, skipping die()")
		return
	is_dead = true
	set_physics_process(false)
	print("Player died!")
	# Fade out before showing LevelFailed
	var fade_overlay = fade_overlay_scene.instantiate()
	get_tree().root.add_child(fade_overlay)
	fade_overlay.fade_out(1.9, show_level_failed)
	

func show_level_failed() -> void:
	var level_failed = level_failed_scene.instantiate()
	get_tree().root.add_child(level_failed)


# Oxygen functions
func take_oxygen(amount: float) -> void:
	current_oxygen -= amount
	current_oxygen = clamp(current_oxygen, 0, max_oxygen)
	update_oxygen_bar()
	if current_oxygen <= 0:
		suffocate()

func refill_oxygen(amount: float) -> void:
	current_oxygen += amount
	current_oxygen = clamp(current_oxygen, 0, max_oxygen)
	update_oxygen_bar()

func update_oxygen_bar() -> void:
	if oxygen_bar:
		oxygen_bar.value = (current_oxygen / max_oxygen) * 100

func suffocate() -> void:
	print("Player suffocated!")
	take_damage(max_health)

# safe zone 
func set_in_safe_zone(value: bool) -> void:
	in_safe_zone = value
	
func add_item(item_name: String, amount: int) -> void:
	if inventory.has(item_name):
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount
	update_inventory_ui()
	print_inventory()  

func remove_item(item_name: String, amount: int) -> void:
	if inventory.has(item_name):
		inventory[item_name] -= amount
		if inventory[item_name] <= 0:
			inventory.erase(item_name)  # Remove item if count reaches 0 or below
		update_inventory_ui()
		print_inventory()  # For debugging

func get_item_count(item_name: String) -> int:
	return inventory.get(item_name, 0)  # Returns 0 if item not found

func print_inventory() -> void:
	print("Inventory: ", inventory)  # Debug output
func update_inventory_ui() -> void:
	if anorite_label:
		anorite_label.text = "Anorite: %d" % get_item_count("Anorite")
	else:
		print("Anorite Label not found")
	if seferon_label:
		seferon_label.text = "Seferon: %d" % get_item_count("Seferon")
	else:
		print("Seferon Label not found")
		
func set_in_dust_storm(value: bool, oxygen_rate: float) -> void:
	in_dust_storm = value
	storm_oxygen_drain = oxygen_rate
	if in_dust_storm:
		$Sprite2D.modulate = Color(0.8, 0.5, 0.3, 0.8)  # Tint brownish when in storm
	else:
		$Sprite2D.modulate = Color.WHITE  # Reset when out

#test function		
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_up"):  # Test with Up Arrow
		#add_item("Anorite", 1)
func check_oxygen_warnings() -> void:
	var oxygen_percent = (current_oxygen / max_oxygen) * 100.0
	if oxygen_percent <= 50.0 and not shown_50_percent_warning:
		spawn_notification("Oxygen at 50%.Stay alert.")
		shown_50_percent_warning = true
	if oxygen_percent <= 15.0 and not shown_10_percent_warning:
		spawn_notification("Critical Warning: Oxygen at 15% !")
		shown_10_percent_warning = true
	# Reset flags if oxygen is restored
	if oxygen_percent > 50.0:
		shown_50_percent_warning = false
	if oxygen_percent > 15.0:
		shown_10_percent_warning = false
func spawn_notification(message: String) -> void:
	var popup = notification_popup_scene.instantiate()
	get_tree().root.add_child(popup)
	popup.show_notification(message)
# Helper function to get HUD nodes safely
# Helper function to initialize HUD nodes
func _initialize_hud_nodes() -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if not hud:
		print("Warning: HUD not found in scene tree")
		return
	health_bar = hud.get_node_or_null("HealthBar")
	oxygen_bar = hud.get_node_or_null("OxygenBar")
	anorite_label = hud.get_node_or_null("AnoriteLabel")
	seferon_label = hud.get_node_or_null("SeferonLabel")
	if health_bar and oxygen_bar and anorite_label and seferon_label:
		hud_initialized = true
	else:
		if not health_bar: print("Warning: HUD node 'HealthBar' not found")
		if not oxygen_bar: print("Warning: HUD node 'OxygenBar' not found")
		if not anorite_label: print("Warning: HUD node 'AnoriteLabel' not found")
		if not seferon_label: print("Warning: HUD node 'SeferonLabel' not found")
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Level_5/scenes/game.tscn")
func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://starting/Scenes/S3.tscn")
