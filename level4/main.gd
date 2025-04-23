extends Control

# === Game Nodes ===
@onready var spaceship = $Spaceship
@onready var path_group = $PathPoints
@onready var word_label = $UILayer/WordLabel
@onready var typing_input = $UILayer/TypingInput
@onready var mistake_label = $UILayer/MistakeLabel
@onready var replay_button = $UILayer/ReplayButton
@onready var ring_counter_label = $UILayer/RingCounter
@onready var inactivity_timer = $InactivityTimer

# === Sounds (AudioStreamPlayer nodes) ===
@onready var move_sound = $MoveSound
@onready var fall_sound = $FallSound
@onready var ding_sound = $DingSound
@onready var music_player = $MusicPlayer

# === Game Variables ===
var letters = "abcdefghijklmnopqrstuvwxyz".split("")
var current_letter = ""
var mistakes = 0
var max_mistakes = 3
var game_active = true
var started = false
var skip_next_fall = false
var fall_speed := 60
var ring_count = 0
var required_rings = 5
var positions = []
var last_position_node: Node2D

# === Initialization ===
func _ready():
	randomize()
	mistakes = 0
	ring_count = 0
	skip_next_fall = false
	game_active = true
	started = false
	positions.clear()

	for p in path_group.get_children():
		if p is Node2D:
			positions.append(p)

	last_position_node = get_closest_position(spaceship.global_position)
	update_ring_counter()

	mistake_label.text = "Mistakes: %d/%d" % [mistakes, max_mistakes]
	replay_button.visible = false
	replay_button.disabled = false
	typing_input.editable = true
	typing_input.clear()
	typing_input.grab_focus()
	typing_input.add_theme_constant_override("caret_width", 0)

	# Timer
	if inactivity_timer.is_connected("timeout", Callable(self, "_on_inactivity_timer_timeout")):
		inactivity_timer.disconnect("timeout", Callable(self, "_on_inactivity_timer_timeout"))
	inactivity_timer.timeout.connect(_on_inactivity_timer_timeout)
	inactivity_timer.wait_time = 10
	inactivity_timer.one_shot = true
	inactivity_timer.start()

	# Music
	if music_player.stream:
		music_player.play()

	new_letter()

# === Game Loop ===
func _physics_process(delta):
	if game_active:
		spaceship.position.y += fall_speed * delta
		typing_input.grab_focus()

func new_letter():
	if not is_inside_tree() or not game_active:
		return
	current_letter = letters[randi() % letters.size()]
	word_label.text = current_letter
	typing_input.clear()
	typing_input.editable = true
	typing_input.grab_focus()
	inactivity_timer.start()

func _on_TypingInput_text_changed(new_text: String) -> void:
	if not game_active: return

	started = true
	var typed = new_text.strip_edges().to_lower()
	var expected = current_letter.to_lower()

	if typed == expected:
		typing_input.clear()
		move_to_nearest("right", true)
	elif typed.length() >= expected.length():
		typing_input.clear()
		mistakes += 1
		mistake_label.text = "Mistakes: %d/%d" % [mistakes, max_mistakes]
		move_to_nearest("left", true)
		check_game_state()

	inactivity_timer.start()

# === Movement ===
func move_to_nearest(direction: String, trigger_new := false):
	var current_pos = spaceship.global_position
	var candidates = []

	for pos in positions:
		if direction == "right" and pos.global_position.x > current_pos.x:
			candidates.append(pos)
		elif direction == "left" and pos.global_position.x < current_pos.x:
			candidates.append(pos)

	if candidates.is_empty():
		if direction == "left" and trigger_new:
			new_letter()
		elif direction == "right":
			game_over(false)
		return

	candidates.sort_custom(func(a, b):
		return a.global_position.distance_to(current_pos) < b.global_position.distance_to(current_pos)
	)

	var target_node = candidates[0]
	last_position_node = target_node
	var tween = create_tween()
	tween.tween_property(spaceship, "global_position", target_node.global_position, 0.5)

	if move_sound:
		move_sound.play()

	if trigger_new:
		tween.tween_callback(func(): if game_active: new_letter())

# === Inactivity Timeout ===
func _on_inactivity_timer_timeout():
	if game_active and started:
		mistakes += 1
		mistake_label.text = "Mistakes: %d/%d" % [mistakes, max_mistakes]

		if last_position_node:
			var tween = create_tween()
			tween.tween_property(spaceship, "global_position", last_position_node.global_position, 0.5)

		if fall_sound:
			fall_sound.play()

		check_game_state()
		inactivity_timer.start()

# === Game State ===
func check_game_state():
	if mistakes >= max_mistakes:
		play_fall_animation()

func play_fall_animation():
	game_active = false
	typing_input.editable = false
	if fall_sound:
		fall_sound.play()
	var tween = create_tween()
	tween.tween_property(spaceship, "rotation_degrees", 180, 1.2)
	tween.tween_property(spaceship, "position:y", spaceship.position.y + 600, 1.2)
	tween.tween_callback(Callable(self, "game_over").bind(false))

func game_over(win):
	if not is_inside_tree(): return
	game_active = false
	inactivity_timer.stop()
	word_label.text = "Mission Successful!" if win else "Mission Failed!"
	typing_input.editable = false
	replay_button.visible = true
	replay_button.disabled = false
	replay_button.grab_focus()

# === Ring Collection ===
func on_ring_collected(ring_node):
	if ding_sound:
		ding_sound.play()

	ring_count += 1
	update_ring_counter()

	if ring_count >= required_rings:
		load_next_scene()

	ring_node.queue_free()

func update_ring_counter():
	ring_counter_label.text = "Rings: %d / %d" % [ring_count, required_rings]

# === Scene Navigation ===
func _on_ReplayButton_pressed():
	get_tree().reload_current_scene()

func load_next_scene():
	game_active = false
	get_tree().change_scene_to_file("res://level4/level-4-gameplay-2/scene/game_play_2_level_4.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://level4/scenes/menu.tscn")

# === Utility ===
func get_closest_position(from_pos: Vector2) -> Node2D:
	var closest: Node2D = null
	var min_dist := INF
	for pos in positions:
		var dist = pos.global_position.distance_to(from_pos)
		if dist < min_dist:
			min_dist = dist
			closest = pos
	return closest
