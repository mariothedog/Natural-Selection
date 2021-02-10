extends Node

var MAIN_SEED = 1612975019503  #OS.get_system_time_msecs()


func _ready() -> void:
	print("Main Seed: ", MAIN_SEED)


func get_new_random_generator() -> RandomNumberGenerator:
	var rnd := RandomNumberGenerator.new()
	rnd.seed = MAIN_SEED
	return rnd


func choice(rng: RandomNumberGenerator, arr: Array):
	return arr[rng.randi() % len(arr)]
