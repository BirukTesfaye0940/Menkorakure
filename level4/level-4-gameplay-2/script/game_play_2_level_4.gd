extends Node2D

@onready var label: Label = $CanvasLayer/Counter/CounterLabel

func _process(_delta: float) -> void:
	label.text = "Rings Passed: %d" % GlobalLevel4.rings_passed
