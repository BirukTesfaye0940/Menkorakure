extends CanvasLayer

# References to UI elements
@onready var habitat_button = $TabContainer/Tab1/HabitatModule
@onready var comms_button = $TabContainer/Tab1/CommunicationTower
@onready var solar_button = $TabContainer/Tab1/SolarArray
@onready var ore_button = $TabContainer/Tab1/OreProcessor
@onready var shield_button = $TabContainer/Tab1/RadiationShield
@onready var oxygen_button = $TabContainer/Tab2/OxygenTank
@onready var suit_button = $TabContainer/Tab2/SuitLevel
@onready var inventory_label = $InventoryLabel

# Upgrade levels (stored here or in Player, depending on persistence needs)
var upgrade_levels = {
	"HabitatModule": 0, "CommunicationTower": 0, "SolarArray": 0,
	"OreProcessor": 0, "RadiationShield": 0,
	"OxygenTank": 1, "SuitLevel": 1
}

# Upgrade costs (Anorite, Seferon) per level
var upgrade_costs = {
	"HabitatModule": [[10, 0], [15, 6], [20, 10]],  # 3 levels
	"CommunicationTower": [[8, 0], [12, 5], [15, 8]],
	"SolarArray": [[9, 0], [15, 6], [20, 10]],
	"OreProcessor": [[8, 0], [12, 5], [15, 9]],
	"RadiationShield": [[10, 0], [15, 5], [20, 10]],
	"OxygenTank": [[10, 0], [15, 5], [20, 10], [23, 15]],  # 5 levels, base free
	"SuitLevel": [[8, 5], [12, 7], [18, 13], [22, 17]]
}

var player = null  # Reference to Player node
@onready var cutscene_scene = preload("res://scenes/cutscene.tscn")

func _ready() -> void:
	# Connect button signals
	habitat_button.pressed.connect(_on_upgrade_pressed.bind("HabitatModule"))
	comms_button.pressed.connect(_on_upgrade_pressed.bind("CommunicationTower"))
	solar_button.pressed.connect(_on_upgrade_pressed.bind("SolarArray"))
	ore_button.pressed.connect(_on_upgrade_pressed.bind("OreProcessor"))
	shield_button.pressed.connect(_on_upgrade_pressed.bind("RadiationShield"))
	oxygen_button.pressed.connect(_on_upgrade_pressed.bind("OxygenTank"))
	suit_button.pressed.connect(_on_upgrade_pressed.bind("SuitLevel"))
	hide()  # Start hidden

func set_player(player_node: Node) -> void:
	player = player_node
	update_ui()

func _on_upgrade_pressed(upgrade_name: String) -> void:
	var current_level = upgrade_levels[upgrade_name]
	var max_levels = upgrade_costs[upgrade_name].size()
	if current_level >= max_levels:
		return  # Already maxed out
	
	var cost = upgrade_costs[upgrade_name][current_level]
	var anorite_cost = cost[0]
	var seferon_cost = cost[1]
	
	# Check inventory
	if player.get_item_count("Anorite") >= anorite_cost and player.get_item_count("Seferon") >= seferon_cost:
		# Deduct resources
		player.remove_item("Anorite", anorite_cost)
		player.remove_item("Seferon", seferon_cost)
		# Upgrade
		upgrade_levels[upgrade_name] += 1
		# Apply effects
		apply_upgrade_effect(upgrade_name)
		update_ui()
		check_win_condition()

#func apply_upgrade_effect(upgrade_name: String) -> void:
	#match upgrade_name:
		#"OxygenTank":
			#player.max_oxygen = 100.0 + (upgrade_levels["OxygenTank"] - 1) * 50.0  # +50 per level
			#player.refill_oxygen(1000.0)  # Refill to new max
func apply_upgrade_effect(upgrade_name: String) -> void:
	match upgrade_name:
		"OxygenTank":
			var level = upgrade_levels.get("OxygenTank", 1)
			var capacity_by_level = {
				1: 100.0,
				2: 210.0,
				3: 320.0,
				4: 470.0,
				5: 590.0
			}
			player.max_oxygen = capacity_by_level.get(level, 100.0)
			player.refill_oxygen(1000.0)  # Refill to new max
		"SuitLevel":
			player.max_health = 250.0 + (upgrade_levels["SuitLevel"] - 1) * 50.0  # +50 per level
			player.heal(1000.0)  # Refill to new max
		# Add effects for Tab 1 upgrades if needed (e.g., print for now)
		_:
			print("%s upgraded to level %d" % [upgrade_name, upgrade_levels[upgrade_name]])

func update_ui() -> void:
	# Update button text with levels and costs
	for upgrade in upgrade_levels.keys():
		var button = get_node("TabContainer/%s/%s" % ["Tab1" if upgrade in ["HabitatModule", "CommunicationTower", "SolarArray", "OreProcessor", "RadiationShield"] else "Tab2", upgrade])
		var level = upgrade_levels[upgrade]
		var max_levels = upgrade_costs[upgrade].size()
		if level < max_levels:
			var cost = upgrade_costs[upgrade][level]
			button.text = "%s (Lv %d) - A:%d S:%d" % [upgrade, level, cost[0], cost[1]]
		else:
			button.text = "%s (Max)" % upgrade
	
	# Update inventory display
	inventory_label.text = "Anorite: %d Seferon: %d" % [player.get_item_count("Anorite"), player.get_item_count("Seferon")]
func check_win_condition() -> void:
	# Check if all Tab 1 components are at max level (3)
	var tab1_components = ["HabitatModule", "CommunicationTower", "SolarArray", "OreProcessor", "RadiationShield"]
	var all_maxed = tab1_components.all(func(comp): return upgrade_levels[comp] >= 3)
	if all_maxed:
		trigger_cutscene()

func trigger_cutscene() -> void:
	var cutscene = cutscene_scene.instantiate()
	get_tree().root.add_child(cutscene)
	hide()  # Hide the upgrade UI during cutscene
	# Optionally pause the game
	get_tree().paused = true
