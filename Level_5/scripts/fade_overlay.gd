extends CanvasLayer

@onready var color_rect = $ColorRect

func fade_out(duration: float, callback: Callable) -> void:
	# Start with transparent black
	color_rect.modulate.a = 0.0
	visible = true
	# Create fade animation
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	tween.tween_callback(callback)  # Call the callback after fade completes
	tween.tween_callback(queue_free)  # Remove self after fade

func _ready() -> void:
	visible = false
