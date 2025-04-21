extends AnimatableBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var detection_area = $Area2D  # Reference to the Area2D

var player_on_platform = false
var time_on_platform = 0.0
const FALL_DELAY = 2.0
var has_fallen = false

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	sprite.animation_finished.connect(_on_animation_finished)  # ✅ Connect when animation ends

func _physics_process(delta: float) -> void:
	if player_on_platform and not has_fallen:
		time_on_platform += delta
		if time_on_platform >= FALL_DELAY:
			collision_shape.disabled = true
			has_fallen = true
			sprite.play("fall")  # ✅ Plays once by default unless `playing` is true forever
	elif not player_on_platform:
		time_on_platform = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_on_platform = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_on_platform = false

func _on_animation_finished() -> void:
	if sprite.animation == "fall":
		# Option A: Safely remove it from the scene after animation finishes
		queue_free()

		# Option B (alternative): Just hide it instead
		#visible = false
