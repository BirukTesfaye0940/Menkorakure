extends Node

var score = 0
@onready var score_label = $Label
@onready var dialog = $Label2

	
func show_dialog():
	dialog.visible = true
	dialog.text = "I get the chest \n Now I have to solve the Puzzle"
