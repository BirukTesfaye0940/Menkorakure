extends Area2D

@export var speed: float = 800.0
@export var max_distance: float = 1000.0
var direction: Vector2 = Vector2.ZERO
var distance_traveled: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	var movement: Vector2 = direction * speed * delta
	position += movement
	distance_traveled += movement.length()
	if distance_traveled > max_distance:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("rocks"):
		body.destroy()
	queue_free()
