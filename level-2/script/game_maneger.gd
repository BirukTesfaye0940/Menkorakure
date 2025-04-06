extends Node

var score = 0
@onready var score_label = $Label
@onready var dialog = $Label2
#func add_point():
	#score +=1
	#score_label.text = "You collected" + " " + str(score) + " " + "coins."
	
func show_dialog():
	dialog.text = "I get the chest Now I have to solve the Puzzle"
