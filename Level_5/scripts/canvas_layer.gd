extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label
@onready var timer = $Panel/Timer

func show_objective(player_position: Vector2) -> void:
	# Position the panel above the player (or use a fixed position)
	var panel_position = player_position + Vector2(0, -100)  # 100 pixels above player
	
	# var panel_position = Vector2(640, 360)  # Center for a 1280x720 window
	#panel.position = panel_position
	# Set objective text
	label.text = """Objective: Survive the harsh environment and build a base by upgrading components in the Spaceship.
Collect Anorite and Seferon ores to upgrade. 
Press Space to dismiss."""
	visible = true
	timer.wait_time = 10  # Show for 5 seconds
	timer.start()
	set_process_input(true)
	print("Showing objective panel at: ", panel_position)

func _ready() -> void:
	visible = false
	timer.timeout.connect(_on_timer_timeout)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # Space key
		print("Space pressed, dismissing objective panel")
		hide_and_free()

func _on_timer_timeout() -> void:
	hide_and_free()

func hide_and_free() -> void:
	visible = false
	queue_free()
