extends Control  # Assuming PauseMenu is a Control node

func _ready():
	# Get buttons
	var resume_btn = %ResumeButton  # Using unique names (%)
	var quit_menu_btn = %QuitMenuButton
	var quit_game_btn = %QuitGameButton

	# Connect buttons to player
	resume_btn.pressed.connect(_on_resume_pressed)
	quit_menu_btn.pressed.connect(_on_quit_menu_pressed)
	quit_game_btn.pressed.connect(_on_quit_game_pressed)

func _on_resume_pressed():
	# Get the Player node from the scene tree (adjust path if needed)
	var player = get_tree().get_first_node_in_group("player") 
	if player:
		player.resume_game()

func _on_quit_menu_pressed():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.quit_to_menu()

func _on_quit_game_pressed():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.quit_game()
