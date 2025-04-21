extends Area2D

@export var speed: float = 300.0
@export var y_variation: float = 80.0

func _ready() -> void:
	add_to_group("ice")
	area_entered.connect(_on_area_entered)
	
	# Calculate the distance to travel (from current x to target x)
	var start_x: float = position.x
	var target_x: float = -100.0
	var distance: float = abs(start_x - target_x)
	
	# Calculate the duration based on speed (distance / speed)
	var duration: float = distance / speed
	
	# Create the tween to move the ice collectible
	var move_tween: Tween = create_tween()
	move_tween.tween_property(self, "position", Vector2(target_x, position.y + randf_range(-y_variation, y_variation)), duration)
	move_tween.tween_callback(queue_free)
   
func _on_area_entered(area: Area2D) -> void:
	print("Ice collectible detected by: ", area.name)
