extends Area2D
@onready var closed_chest = $closedChest
@onready var opend_chest = $openedChest
@onready var  game_maneger = %GameManeger
@onready var dialog = $"../GameManeger/Label2"

var counter = 1

func _on_body_entered(body: Node2D) -> void:
		print(body.name)
		closed_chest.visible = false
		opend_chest.visible = true
		game_maneger.show_dialog()
		dialog.visible = true
		if counter:
			game_maneger.add_point()
			counter -=1
		
		
		
