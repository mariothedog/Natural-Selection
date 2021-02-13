extends Node

const TIME_SCALE := 10

var _elapsed_time := 0.0

onready var graph: Node2D = $Graph


func _process(delta: float) -> void:
	_elapsed_time += delta


func _on_AddPoint_timeout() -> void:
	graph.add_point(Vector2(round(_elapsed_time * TIME_SCALE), round(rand_range(-100, 100))))
