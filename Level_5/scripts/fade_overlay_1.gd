extends CanvasLayer

@onready var color_rect = $ColorRect
var fade_callback: Callable

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0)  # Start transparent

func fade_out(duration: float, callback: Callable) -> void:
	fade_callback = callback
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration)  # Fade to black
	tween.tween_callback(_on_fade_complete)

func _on_fade_complete() -> void:
	if fade_callback:
		fade_callback.call()
	queue_free()  # Remove the fade overlay after fading

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		print("FadeOverlay_1 scene freed")
