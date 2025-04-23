extends Control

@onready var start_btn = $StartButton

func _ready():
	print(start_btn)  # Optional debug
	start_btn.pressed.connect(_on_start_btn_pressed)

func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://level4/scenes/main.tscn")
