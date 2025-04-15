extends Node2D
var database : SQLite
var selected_avatar : int = 0  # To store avatar selection

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()
	_createTable()

func _process(delta: float) -> void:
	pass

func _createTable():
	var table = {
		"id" : {"data_type" : "int", "primary_key" : true, "not_null" : true, "auto_increment" : true},
		"name" : {"data_type" : "text"},
		"age" : {"data_type" : "int"},
		"avatar_id" : {"data_type" : "int"}  # Add avatar column
	}
	database.create_table("player53", table)

func _on_main_menu_pressed() -> void:
	var data = {
		"name" : $Panel/Labels/TextEdit.text,
		"age" : int($Panel/Labels/TextEdit2.text),
		"avatar_id" : selected_avatar
	}
	database.insert_row("player53", data)  # Insert data into table
	get_tree().change_scene_to_file("res://Starting/Scenes/S3.tscn")

# Avatar button handlers
func _on_avatar_1_pressed() -> void:
	selected_avatar = 1

func _on_avatar_2_pressed() -> void:
	selected_avatar = 2

func _on_avatar_3_pressed() -> void:
	selected_avatar = 3

func _on_avatar_4_pressed() -> void:
	selected_avatar = 4
