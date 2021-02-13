extends CanvasLayer

var average_speed := 0.0

var _population_speeds := []

onready var average_speed_label: Label = $MarginContainer/AverageSpeed


func _on_TimeScale_time_scale_changed(time_scale: int) -> void:
	Engine.time_scale = time_scale
	if time_scale == 0:
		Engine.iterations_per_second = 60
	else:
		Engine.iterations_per_second = 60 * time_scale


func append_population_speed(speed: float) -> void:
	_population_speeds.append(speed)
	update_average_speed()


func erase_population_speed(speed: float) -> void:
	_population_speeds.erase(speed)
	update_average_speed()


func update_average_speed() -> void:
	if _population_speeds:
		average_speed = Util.average(_population_speeds)
		average_speed_label.text = "Average Speed: %f" % average_speed
