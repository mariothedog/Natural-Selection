extends Node


func _ready() -> void:
	var msec := OS.get_system_time_msecs()
	print("Seed: ", msec)
	seed(msec)


static func choice(arr: Array):
	return arr[randi() % len(arr)]
