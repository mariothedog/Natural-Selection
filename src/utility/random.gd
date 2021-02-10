extends Node

onready var main_seed = OS.get_system_time_msecs()


func _ready() -> void:
	print("Main Seed: ", main_seed)


func get_new_random_generator() -> RandomNumberGenerator:
	var rnd := RandomNumberGenerator.new()
	rnd.seed = main_seed
	return rnd


func choice(rng: RandomNumberGenerator, arr: Array):
	return arr[rng.randi() % len(arr)]
