extends Node

var score = 0
@onready var score_label = $Label
@onready var score_label4 = $Label4
@onready var score_label5 = $Label5
@onready var score_label6 = $Label6
@onready var score_label3 = $Label3
@onready var score_label2 = $Label2
@onready var dialog = $Label2
func add_point():
	score +=1
	score_label.text = "You collected" + " " + str(score) + " " + "coins."
	score_label2.text = "You collected" + " " + str(score) + " " + "coins."
	score_label3.text = "You collected" + " " + str(score) + " " + "coins."
	score_label4.text = "You collected" + " " + str(score) + " " + "coins."
	score_label5.text = "You collected" + " " + str(score) + " " + "coins."
	score_label6.text = "You collected" + " " + str(score) + " " + "coins."
func show_dialog():
	dialog.text = "You successfully reach the final \n challenge let's go the puzzle"
