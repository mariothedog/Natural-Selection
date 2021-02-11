extends CanvasLayer


func _on_TimeScale_time_scale_changed(time_scale: int) -> void:
	Engine.time_scale = time_scale
	if time_scale == 0:
		Engine.iterations_per_second = 60
	else:
		Engine.iterations_per_second = 60 * time_scale
