extends Area2D

var damage_timer: Timer  # Timer to continuously reduce health
var player_inside: bool = false  # Track if player is inside

func _ready() -> void:
	damage_timer = Timer.new()
	damage_timer.wait_time = 1.0  # Time interval for health reduction (adjust as needed)
	damage_timer.autostart = false
	damage_timer.one_shot = false
	damage_timer.connect("timeout", Callable(self, "_apply_damage"))
	add_child(damage_timer)

func _on_body_entered(body: Node2D) -> void:
		player_inside = true
		_apply_damage()  # Apply initial damage immediately
		damage_timer.start()  # Start continuous damage

func _on_body_exited(_body: Node2D) -> void:
		player_inside = false
		damage_timer.stop()  # Stop damage when the player leaves

func _apply_damage() -> void:
	if player_inside:
		Global.healthT -= 1
		get_tree().call_group('CanvasLayer', 'set_health', Global.healthT)
		if Global.healthT <= 0:
			call_deferred("restart_scene")

func restart_scene() -> void:
	get_tree().reload_current_scene()
