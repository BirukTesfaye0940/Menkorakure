extends AnimatableBody2D

@onready var detection_area = $Area2D
@onready var explosion_sprite = $Explosion
@onready var explosion_area = $Explosion/ExplosionArea

var player_inside = false
var player_node: Node = null
var explosion_triggered = false

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	explosion_area.body_entered.connect(_on_explosion_area_entered)

func _physics_process(_delta: float) -> void:
	if player_inside and not explosion_triggered:
		if Input.is_action_pressed("run"):  # Running check
			explosion_triggered = true
			explosion_sprite.play("explode")  # Play explosion animation

func _on_body_entered(body: Node) -> void:
	player_inside = true
	player_node = body

func _on_body_exited(_body: Node) -> void:
	player_inside = false
	player_node = null

func _on_explosion_area_entered(_body: Node) -> void:
	if explosion_triggered:
		Global.healthT -= 1
		if Global.healthT <= 0:
			call_deferred("restart_scene")

func restart_scene() -> void:
	Global.healthT = 4
	Global.current_gameplay_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Scene/game_over.tscn")
