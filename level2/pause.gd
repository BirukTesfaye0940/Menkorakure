extends ColorRect

func _ready() -> void:
	$"../AnimationPlayer".play("RESET")
func resume():
	get_tree().paused = false
	$"../AnimationPlayer".play_backwards("blur")
func pause():
	get_tree().paused = true
	$"../AnimationPlayer".play("blur")
func testEsc():
	if Input.is_action_just_pressed('esc') and ! get_tree().paused:
		pause()
	elif Input.is_action_just_pressed('esc') and get_tree().paused:
		resume()
	


func _on_resume_pressed() -> void:
	resume() # Replace with function body.


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()# Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	testEsc()
