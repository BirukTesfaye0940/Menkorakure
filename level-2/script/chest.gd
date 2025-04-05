extends Area2D
@onready var closed_chest = $closedChest
@onready var opend_chest = $openedChest
@onready var  game_maneger = %GameManeger
@onready var dialog = $"../GameManeger/Label2"
@onready var player = $"../player"

var counter = 1


func _on_body_entered(body: Node2D) -> void:
		closed_chest.visible = false
		opend_chest.visible = true
		game_maneger.show_dialog()
		dialog.visible = true
		if counter:
			player.add_point()
			counter = 0
		
		
		
		
