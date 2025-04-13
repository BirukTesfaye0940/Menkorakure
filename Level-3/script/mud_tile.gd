extends AnimatableBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var detection_area = $Area2D  # Reference to the Area2D

var player_on_platform = false

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	player_on_platform = true

func _on_body_exited(body: Node2D) -> void:
	player_on_platform = false
