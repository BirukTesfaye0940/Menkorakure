extends "res://addons/gut/test.gd"

var UpgradeUI = load("res://level5/scenes/upgrade_ui.tscn")
var upgrade_ui: CanvasLayer
var mock_player: Node

func before_all():
	# Preload any shared resources
	pass

func before_each():
	upgrade_ui = autofree(UpgradeUI.instantiate())
	mock_player = autofree(Node.new())
	
	# Mock player methods
	mock_player.get_item_count = func(_item): return 100  # Always has enough resources
	mock_player.remove_item = func(_item, _amount): pass
	mock_player.max_oxygen = 100.0
	mock_player.max_health = 100.0
	mock_player.refill_oxygen = func(_amount): pass
	mock_player.heal = func(_amount): pass
	
	# Spy on player methods
	stub(mock_player, "get_item_count").to_return(100)
	stub(mock_player, "remove_item").to_do_nothing()
	stub(mock_player, "refill_oxygen").to_do_nothing()
	stub(mock_player, "heal").to_do_nothing()
	
	upgrade_ui.set_player(mock_player)

func test_ready_connects_signals_and_hides_ui():
	upgrade_ui._ready()
	assert_connected(upgrade_ui.habitat_button, upgrade_ui, "pressed", "_on_upgrade_pressed")
	assert_connected(upgrade_ui.suit_button, upgrade_ui, "pressed", "_on_upgrade_pressed")
	assert_false(upgrade_ui.visible, "UI should start hidden")

func test_set_player_updates_reference_and_ui():
	var new_player = autofree(Node.new())
	new_player.get_item_count = func(_item): return 50
	stub(new_player, "get_item_count").to_return(50)
	
	upgrade_ui.set_player(new_player)
	assert_eq(upgrade_ui.player, new_player, "Player reference should update")
	# Can't directly test UI updates without full scene tree, but we test update_ui separately

func test_upgrade_pressed_with_resources():
	var initial_level = upgrade_ui.upgrade_levels["OxygenTank"]
	upgrade_ui._on_upgrade_pressed("OxygenTank")
	
	assert_eq(upgrade_ui.upgrade_levels["OxygenTank"], initial_level + 1,
		"Upgrade level should increment when resources are available")
	assert_called(mock_player, "remove_item", ["Anorite", 10])
	assert_called(mock_player, "remove_item", ["Seferon", 0])

func test_upgrade_pressed_without_resources():
	stub(mock_player, "get_item_count").to_return(0)  # No resources
	
	var initial_level = upgrade_ui.upgrade_levels["SuitLevel"]
	upgrade_ui._on_upgrade_pressed("SuitLevel")
	
	assert_eq(upgrade_ui.upgrade_levels["SuitLevel"], initial_level,
		"Upgrade level should not change without resources")

func test_apply_upgrade_effect_oxygen_tank():
	upgrade_ui.upgrade_levels["OxygenTank"] = 1
	upgrade_ui.apply_upgrade_effect("OxygenTank")
	
	assert_eq(mock_player.max_oxygen, 210.0, "Oxygen capacity should increase to level 2 value")
	assert_called(mock_player, "refill_oxygen", [1000.0])

func test_apply_upgrade_effect_suit_level():
	upgrade_ui.upgrade_levels["SuitLevel"] = 2
	upgrade_ui.apply_upgrade_effect("SuitLevel")
	
	assert_eq(mock_player.max_health, 300.0, "Health should increase to level 3 value (250 + 50)")
	assert_called(mock_player, "heal", [1000.0])

func test_check_win_condition_triggers_cutscene():
	# Max out all Tab1 upgrades
	for upgrade in ["HabitatModule", "CommunicationTower", "SolarArray", "OreProcessor", "RadiationShield"]:
		upgrade_ui.upgrade_levels[upgrade] = 3
	
	watch_signals(upgrade_ui)
	upgrade_ui.check_win_condition()
	
	assert_true(upgrade_ui.visible == false, "UI should hide when cutscene triggers")
	# Can't fully test cutscene instantiation without scene tree

func test_update_ui_button_text_and_inventory():
	upgrade_ui.update_ui()
	
	# Verify inventory label format
	var label_text = upgrade_ui.inventory_label.text
	assert_true("Anorite:" in label_text and "Seferon:" in label_text,
		"Inventory label should display both resource types")
	
	# Verify button text contains level info
	var button_text = upgrade_ui.habitat_button.text
	assert_true("Lv" in button_text or "Max" in button_text,
		"Upgrade buttons should show current level or 'Max'")
