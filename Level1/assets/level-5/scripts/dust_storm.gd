extends Area2D

@export var speed: float = 5.0  # Pixels per second (slow movement)
@export var oxygen_drain_rate: float = 8.0  # Oxygen drain per second in storm

var direction: Vector2 = Vector2.RIGHT  # Default movement direction
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		connect("body_entered", _on_body_entered)
	if not is_connected("body_exited", _on_body_exited):
		connect("body_exited", _on_body_exited)
	# Ensure animation plays
	#if animated_sprite:
		#animated_sprite.play("storm")  # Replace "storm" with your animation name

func _physics_process(delta: float) -> void:
	# Move the storm slowly
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		# Start draining when player enters
		body.set_in_dust_storm(true, oxygen_drain_rate)

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		# Stop draining when player exits
		body.set_in_dust_storm(false, 0.0)
