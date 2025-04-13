extends Node2D
@onready var lebel = $Label
@onready var  timer = $Timer
@onready var total_time_insecond : int =  0


func _on_ready() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	total_time_insecond +=1
	var m = int(total_time_insecond/60)
	var s = int(total_time_insecond-m*60)
	$Label.text = "%02d:%02d" % [m, s]
	
	if (total_time_insecond == 3600):
		total_time_insecond = 0
