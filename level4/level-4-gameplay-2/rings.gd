extends Area2D

var has_been_passed := false  # Prevents multiple counts for one ring

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if has_been_passed:
		return

	if body.is_in_group("rocket"):  # Assuming the rocket is in a group named "rocket"
		Global.rings_passed += 1
		has_been_passed = true
		print("Ring passed! Total:", Global.rings_passed)
		call_deferred("queue_free")  # Correct usage
