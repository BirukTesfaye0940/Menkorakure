extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite = $AnimatedSprite2D


@onready var anorite_label = get_node("/root/Hud/AnoriteLabel")
@onready var seferon_label = get_node("/root/Hud/SeferonLabel")

# Health variables 
@export var max_health: float = 250.0
var current_health: float = max_health
#@onready var health_bar = $HealthBar
@onready var health_bar = get_node("/root/Hud/HealthBar")
#oxygen variable
@export var max_oxygen: float = 100.0  # Max oxygen capacity
var current_oxygen: float = max_oxygen  # Current oxygen level
@export var oxygen_drain_rate: float = 0.8  # Oxygen lost per second
@export var oxygen_jump_cost: float = 1.9  # Oxygen lost per jump
#@onready var oxygen_bar = $OxygenBar  # Reference to oxygen bar UI
#@onready var oxygen_bar: ProgressBar = $OxygenBar
@onready var oxygen_bar = get_node("/root/Hud/OxygenBar")

# Safe zone flag
var in_safe_zone: bool = false

# Inventory
var inventory: Dictionary = {
	"Anorite": 0,  # Starting
	"Seferon": 0   # Starting with 0
}

# Dust storm variables
var in_dust_storm: bool = false
var storm_oxygen_drain: float = 0.0

func _ready() -> void:
	# Initialize health and oxygen bars
	add_to_group("player")
	update_health_bar()
	update_oxygen_bar()
	update_inventory_ui()
func _physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if not in_safe_zone:
			take_oxygen(oxygen_jump_cost)
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

func die() -> void:
	print("Player died!")
	get_tree().reload_current_scene()

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
	if seferon_label:
		seferon_label.text = "Seferon: %d" % get_item_count("Seferon")
		
		
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
