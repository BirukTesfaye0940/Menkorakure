extends Node2D

const SEGMENTS = 8
const SNAP_ANGLE = 45.0
const OUTER_RADIUS = 250
const MIDDLE_RADIUS = 190
const INNER_RADIUS = 125
const TIME_LIMIT = 60.0
const BORDER_COLOR = Color(0.8, 0.7, 0.2)
const BORDER_WIDTH = 8.0

const COLORS = {
	"outer_segment": Color(0.2, 0.8, 0.2, 0.5),
	"middle_segment": Color(0.8, 0.8, 0.2, 0.5),
	"inner_segment": Color(0.8, 0.2, 0.2, 0.5),
	"button": Color(0.5, 0.3, 0.1),
	"button_hover": Color(0.6, 0.4, 0.2)
}

var outer_symbols = ["፳፩", "፪", "፫", "E", "፭", "፮", "፯", "መስ", "፩"]
var middle_symbols = ["፩", "ከ","፪", "፫", "=", "፬", "፻፳", "፮"]
var inner_symbols = ["mc²", "፪", "፫", "፬", "ረም", "፭", "፮", "፭"]




var valid_combinations = {
	"E=mc²": "E = mc²",
	"፳፩፻፳፭": "Launch Year: ፳፩፻፳፭",
	"መስከረም": "Month: መስከረም"
}


@onready var outer_ring = $OuterRing
@onready var middle_ring = $MiddleRing
@onready var inner_ring = $InnerRing
@onready var confirm_button = $ConfirmButton
@onready var instruction_label = $InstructionLabel
@onready var ring_borders = $RingBorders
@onready var live_combo_label = Label.new()
@onready var solved_label_container = VBoxContainer.new()


var timer_label: Label
var timer_bg: ColorRect
var solved_equations = []
var equation_labels = []

var current_ring = null
var is_dragging = false
var drag_start_angle = 0.0
var puzzle_solved = false
var time_remaining = TIME_LIMIT
var timer_active = true
var how_to_play = Label.new()




func _ready():
	setup_rings()
	setup_borders()
	setup_confirm_button()
	setup_timer_label()
	start_timer()
	update_progress_label()
	set_process_unhandled_input(true)
	set_process(true)
	live_combo_label = Label.new()
	live_combo_label.position = Vector2(800, 120)
	live_combo_label.add_theme_font_size_override("font_size", 26)
	live_combo_label.add_theme_color_override("font_color", Color(1, 1, 1))
	add_child(live_combo_label)
	solved_label_container.position = Vector2(850, 300)
	add_child(solved_label_container)
	how_to_play.position = Vector2(20, 20)
	how_to_play.text = """
	🎮 How to Play:
	🔁 Rotate Rings (Q/W, A/S, Z/X)
	🖱️ Click-Drag to Rotate
	✅ Press Confirm to Check
	🎯 Find All 3 Combinations
	"""
	how_to_play.add_theme_font_size_override("font_size", 18)
	how_to_play.add_theme_color_override("font_color", Color(1, 1, 0.8))
	add_child(how_to_play)


func setup_rings():
	create_segments(outer_ring, outer_symbols, OUTER_RADIUS)
	create_segments(middle_ring, middle_symbols, MIDDLE_RADIUS)
	create_segments(inner_ring, inner_symbols, INNER_RADIUS)

func create_segments(ring: Node2D, symbols: Array, radius: float):
	for i in range(SEGMENTS):
		var segment = Node2D.new()
		segment.name = "Segment_%d" % i

		var bg = ColorRect.new()
		bg.size = Vector2(60, 60)
		bg.position = Vector2(-30, -30)
		if ring == outer_ring:
			bg.color = COLORS.outer_segment
		elif ring == middle_ring:
			bg.color = COLORS.middle_segment
		else:
			bg.color = COLORS.inner_segment


		var label_container = Node2D.new()
		label_container.name = "LabelContainer"

		var label = Label.new()
		label.text = symbols[i]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(60, 60)
		label.position = Vector2(-30, -30)
		label.add_theme_font_size_override("font_size", 32)
		label.add_theme_color_override("font_color", Color.WHITE)

		var angle = deg_to_rad((360.0 / SEGMENTS) * i)
		segment.position = Vector2(cos(angle) * (radius - 30), sin(angle) * (radius - 30))

		label_container.add_child(label)
		segment.add_child(bg)
		segment.add_child(label_container)
		ring.add_child(segment)

func setup_borders():
	if not ring_borders:
		push_error("Missing RingBorders node")
		return

	create_ring_border(ring_borders.get_node("OuterBorder"), OUTER_RADIUS + 10)
	create_ring_border(ring_borders.get_node("MiddleBorder"), MIDDLE_RADIUS + 10)
	create_ring_border(ring_borders.get_node("InnerBorder"), INNER_RADIUS + 10)

func create_ring_border(line: Line2D, radius: float):
	if not line: return
	line.default_color = BORDER_COLOR
	line.width = BORDER_WIDTH

	var points = []
	for i in range(SEGMENTS + 1):
		var angle = deg_to_rad((360.0 / SEGMENTS) * i)
		points.append(Vector2(cos(angle) * radius, sin(angle) * radius))
	points.append(points[0])
	line.points = points

func setup_confirm_button():
	if not confirm_button:
		push_error("Missing ConfirmButton node")
		return

	confirm_button.text = "Confirm"
	# Center of the screen or ring area (adjust offset if needed)
	confirm_button.position = Vector2(480, 300)
	confirm_button.anchor_left = 0.5
	confirm_button.anchor_top = 0.5
	confirm_button.anchor_right = 0.5
	confirm_button.anchor_bottom = 0.5
	confirm_button.pivot_offset = confirm_button.size / 2


	var style = StyleBoxFlat.new()
	style.bg_color = COLORS.button
	style.set_border_width_all(2)
	style.border_color = BORDER_COLOR
	style.set_corner_radius_all(8)

	var style_hover = style.duplicate()
	style_hover.bg_color = COLORS.button_hover
	style_hover.border_color = BORDER_COLOR.lightened(0.2)

	confirm_button.add_theme_stylebox_override("normal", style)
	confirm_button.add_theme_stylebox_override("hover", style_hover)
	confirm_button.add_theme_stylebox_override("pressed", style_hover)
	confirm_button.add_theme_font_size_override("font_size", 16)
	confirm_button.add_theme_color_override("font_color", Color(1, 1, 0.9))

	confirm_button.pressed.connect(_on_confirm_pressed)

func setup_timer_label():
	timer_bg = ColorRect.new()
	timer_bg.color = Color(0.2, 0.2, 0.2, 0.7)
	timer_bg.size = Vector2(150, 50)
	timer_bg.position = Vector2(850, 35)
	add_child(timer_bg)

	timer_label = Label.new()
	timer_label.text = format_time(time_remaining)
	timer_label.add_theme_font_size_override("font_size", 32)
	timer_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.7))
	timer_label.position = Vector2(900, 50)
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(timer_label)

func format_time(seconds: float) -> String:
	var minutes = floor(seconds / 60)
	var secs = floor(fmod(seconds, 60))
	return "%02d:%02d" % [minutes, secs]

func start_timer():
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	if not timer_active or puzzle_solved: return
	time_remaining -= 1
	timer_label.text = format_time(time_remaining)
	if time_remaining <= 0:
		timer_active = false
		show_time_up()

func _unhandled_input(event):
	if puzzle_solved or not timer_active: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag(event.position)
			else:
				end_drag()

	elif event is InputEventMouseMotion and is_dragging:
		handle_drag(event.position)
	elif event is InputEventKey and event.pressed and not event.is_echo():
		match event.key_label:
			KEY_Q: rotate_ring_by_angle(outer_ring, -deg_to_rad(SNAP_ANGLE))
			KEY_W: rotate_ring_by_angle(outer_ring, deg_to_rad(SNAP_ANGLE))
			KEY_A: rotate_ring_by_angle(middle_ring, -deg_to_rad(SNAP_ANGLE))
			KEY_S: rotate_ring_by_angle(middle_ring, deg_to_rad(SNAP_ANGLE))
			KEY_Z: rotate_ring_by_angle(inner_ring, -deg_to_rad(SNAP_ANGLE))
			KEY_X: rotate_ring_by_angle(inner_ring, deg_to_rad(SNAP_ANGLE))

func start_drag(pos):
	is_dragging = true
	drag_start_angle = (pos - global_position).angle()
	for ring in [outer_ring, middle_ring, inner_ring]:
		if ring.get_global_transform().origin.distance_to(pos) < OUTER_RADIUS:
			current_ring = ring
			break

func end_drag():
	is_dragging = false
	current_ring = null

func handle_drag(pos):
	if not current_ring: return
	var current_angle = (pos - global_position).angle()
	var delta = current_angle - drag_start_angle
	drag_start_angle = current_angle
	rotate_ring_by_angle(current_ring, delta)

func rotate_ring_by_angle(ring: Node2D, angle: float):
	ring.rotation = wrapf(ring.rotation + angle, 0, 2 * PI)
	for segment in ring.get_children():
		var label_container = segment.get_node("LabelContainer")
		if label_container:
			label_container.rotation = -ring.rotation

func get_top_segment_index(ring: Node2D) -> int:
	var angle = wrapf(ring.rotation, 0, 2 * PI)
	var segment_size = (2 * PI) / SEGMENTS
	var base_index = int(round(angle / segment_size)) % SEGMENTS
	
	var offset = 0
	if ring == outer_ring:
		offset = 2  # adjust this after testing
	elif ring == middle_ring:
		offset = 2  # adjust this after testing
	elif ring == inner_ring:
		offset = 2  # adjust this after testing
	
	var corrected_index = (base_index + offset) % SEGMENTS
	return corrected_index


func _process(delta):
	if live_combo_label:
		live_combo_label.text = "🔄 Current Combo: %s%s%s" % [
			outer_symbols[get_top_segment_index(outer_ring)],
			middle_symbols[get_top_segment_index(middle_ring)],
			inner_symbols[get_top_segment_index(inner_ring)]
		]





func _on_confirm_pressed():
	if puzzle_solved or not timer_active: return
	for ring in [outer_ring, middle_ring, inner_ring]:
		ring.rotation = round(ring.rotation / deg_to_rad(SNAP_ANGLE)) * deg_to_rad(SNAP_ANGLE)
		for segment in ring.get_children():
			var label_container = segment.get_node("LabelContainer")
			if label_container:
				label_container.rotation = -ring.rotation
	await get_tree().process_frame
	check_solution()

func check_solution():
	var outer_index = get_top_segment_index(outer_ring)
	var middle_index = get_top_segment_index(middle_ring)
	var inner_index = get_top_segment_index(inner_ring)

	var outer_symbol = outer_symbols[outer_index]
	var middle_symbol = middle_symbols[middle_index]
	var inner_symbol = inner_symbols[inner_index]

	var combo = outer_symbol + middle_symbol + inner_symbol
	print("Top Indices => Outer:%d Middle:%d Inner:%d" % [outer_index, middle_index, inner_index])
	print("Symbols => %s%s%s" % [outer_symbol, middle_symbol, inner_symbol])
	print("Generated combo:%s" % combo)

	if valid_combinations.has(combo) and not solved_equations.has(combo):
		solved_equations.append(combo)
		show_solved_equation(valid_combinations[combo])
		update_progress_label()
		show_unlock_animation("🎉 Found: " + valid_combinations[combo])

		if solved_equations.size() == valid_combinations.size():
			puzzle_solved = true
			timer_active = false
			show_success()
	else:
		show_info_popup("Try again or rotate more!")


func show_solved_equation(eq: String):
	var lbl = Label.new()
	lbl.text = "✅ " + eq
	lbl.position = Vector2(800,800)
	lbl.add_theme_font_size_override("font_size", 22)
	lbl.add_theme_color_override("font_color", Color(0.7, 1.0, 0.7))
	solved_label_container.add_child(lbl)


func update_progress_label():
	instruction_label.text = "Solved: %d / 3" % solved_equations.size()
	instruction_label.add_theme_font_size_override("font_size", 24)
	instruction_label.add_theme_color_override("font_color", Color(1, 1, 0.9))

func show_info_popup(msg: String):
	var popup = Label.new()
	popup.text = msg
	popup.add_theme_font_size_override("font_size", 26)
	popup.add_theme_color_override("font_color", Color(1, 1, 0.8))
	popup.position = Vector2(200, 400)
	popup.modulate.a = 0
	add_child(popup)
	var tween = create_tween()
	tween.tween_property(popup, "modulate:a", 1.0, 0.3)
	tween.tween_interval(2.0)
	tween.tween_property(popup, "modulate:a", 0.0, 0.3)
	tween.tween_callback(popup.queue_free)
func show_unlock_animation(message: String):
	var label = Label.new()
	label.text = message
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
	label.position = Vector2(400, 300)
	label.modulate.a = 0
	add_child(label)

	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	tween.tween_property(label, "position:y", 200, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.6)
	tween.tween_callback(label.queue_free)

func show_success():
	# Success text popup
	var popup = Label.new()
	popup.text = "🎉 Blueprint Complete! 🎉"
	popup.add_theme_font_size_override("font_size", 44)
	popup.add_theme_color_override("font_color", Color(1, 0.9, 0.6))
	popup.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup.position = Vector2(300, 200)
	popup.modulate.a = 0
	add_child(popup)

	# Flash overlay
	var flash = ColorRect.new()
	flash.color = Color(1, 1, 1, 0.0)
	flash.size = get_viewport_rect().size
	add_child(flash)

	# Tween popup and flash
	var tween = create_tween()
	tween.tween_property(popup, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(1.5)
	tween.tween_property(popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(popup.queue_free)

	tween.parallel().tween_property(flash, "color:a", 0.4, 0.2)
	tween.parallel().tween_property(flash, "color:a", 0.0, 0.4)
	tween.tween_callback(flash.queue_free)

	# Colorful falling droplets / fireworks
	var particles = GPUParticles2D.new()
	particles.position = Vector2(480, 270)
	particles.amount = 300  # Increased
	particles.lifetime = 2.5
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.speed_scale = 1.2

	var material = ParticleProcessMaterial.new()
	material.gravity = Vector3(0, 600, 0)
	material.initial_velocity_min = 250
	material.initial_velocity_max = 600
	material.direction = Vector3(0, -1, 0)
	material.spread = 360.0  # Full burst
	material.scale_min = 0.3
	material.scale_max = 0.8
	material.angle_min = -30
	material.angle_max = 30
	material.angular_velocity_min = -3
	material.angular_velocity_max = 3

	# Color ramp for shimmer
	var color_ramp = GradientTexture1D.new()
	var gradient = Gradient.new()
	gradient.add_point(0.0, Color(1, 0.6, 0.2))
	gradient.add_point(0.5, Color(1, 1, 0.5))
	gradient.add_point(1.0, Color(0.8, 1.0, 0.4))
	color_ramp.gradient = gradient
	material.color_ramp = color_ramp

	particles.process_material = material
	add_child(particles)
	particles.restart()

func show_time_up():
	var popup = create_popup("Time's Up!", Color(1, 0.3, 0.3))
	add_child(popup)
	animate_popup(popup)
	var replay_button = Button.new()
	replay_button.text = "Play Again!"
	replay_button.size = Vector2(50, 50)
	replay_button.position = Vector2(800, 160)  # Adjust as needed
	replay_button.add_theme_font_size_override("font_size", 18)
	replay_button.add_theme_color_override("font_color", Color.WHITE)

	# Optional styling
	var style = StyleBoxFlat.new()
	style.bg_color = COLORS.button
	style.set_border_width_all(2)
	style.border_color = BORDER_COLOR
	style.set_corner_radius_all(8)

	replay_button.pressed.connect(_on_replay_pressed)
	add_child(replay_button)
	
func _on_replay_pressed():
	get_tree().reload_current_scene()


func create_popup(text: String, color: Color) -> Label:
	var popup = Label.new()
	popup.text = text
	popup.add_theme_font_size_override("font_size", 32)
	popup.add_theme_color_override("font_color", color)
	popup.position = Vector2(100, 200)
	popup.modulate.a = 0
	return popup

func animate_popup(popup: Label):
	var tween = create_tween()
	tween.tween_property(popup, "modulate:a", 1.0, 0.3)
	tween.tween_interval(1.2)
	tween.tween_property(popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(popup.queue_free)
