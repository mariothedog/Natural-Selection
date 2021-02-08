extends Node


func _ready() -> void:
	var msec := OS.get_system_time_msecs()
	print("Seed: ", msec)
	seed(msec)
