
extends Control

var seconds = 0
var minutes = 3
var is_timer_running=false

func _ready() -> void:
	reset_timer()
	if $countDownTimer:
		$countDownTimer.start()
		is_timer_running =true

func _on_timer_timeout() -> void:
	if seconds == 0:
		if minutes == 0:
			$countDownTimer.stop()
			is_timer_running=false
			return
		else:
			minutes -=1
			seconds=59
	else:
		seconds -= 1
		# Properly formatted time display
		$timeLabel.text = "%02d:%02d" % [minutes, seconds]

func reset_timer():
	seconds = 0
	minutes = 3
	# Update display immediately
	$timeLabel.text = "03:00"
