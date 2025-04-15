extends CanvasLayer

@onready var label = $Panel/Label
@onready var timer = $Panel/Timer

func show_notification(message: String) -> void:
	label.text = message
	visible = true
	timer.start()
	print("Showing notification: ", message)

func _ready() -> void:
	visible = false  # Hidden by default
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	visible = false
	queue_free()  # Remove after showing
