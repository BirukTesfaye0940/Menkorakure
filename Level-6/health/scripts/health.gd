extends Node

class_name HealthManager

@export var max_health: float = 1000.0
var current_health: float = 1000.0
var is_invulnerable: bool = false

signal health_changed(current: float, maximum: float)
signal died

func _ready() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)

func apply_damage(amount: float) -> void:
	if is_invulnerable:
		print("Damage ignored. Player is invulnerable.")
		return
	
	current_health = max(0, current_health - amount)
	emit_signal("health_changed", current_health, max_health)
	if current_health <= 0:
		die()

func apply_heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health, max_health)

func set_invulnerable(state: bool, duration: float = 0.0) -> void:
	is_invulnerable = state
	if state and duration > 0:
		await get_tree().create_timer(duration).timeout
		is_invulnerable = false

func die() -> void:
	emit_signal("died")
	print("Game over or rocket destroyed!")
