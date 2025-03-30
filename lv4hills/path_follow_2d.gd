extends PathFollow2D

var speed: float = 0.02  # Lower value means slower movement

func _process(delta: float) -> void:
	progress_ratio += speed * delta
	if progress_ratio >= 1.0:
		progress_ratio -= 1.0
