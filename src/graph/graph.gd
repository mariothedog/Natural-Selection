extends Node2D

export var positive_width := 100.0
export var negative_width := 100.0
export var positive_height := 100.0
export var negative_height := 100.0

const ORIGIN := Vector2.ZERO
const AXIS_WIDTH := 1.0
const IS_ANTIALISED := true

var _raw_points := PoolVector2Array([Vector2.ZERO])
var _default_font := Control.new().get_font("")
var _offset_x_axis := Vector2.ZERO
var _offset_y_axis := Vector2.ZERO

onready var line: Line2D = $Line2D


func _process(_delta: float) -> void:
	update()


func add_point(pos: Vector2) -> void:
	var point := Vector2(pos.x, -pos.y)  # In Godot, up is negative, and down is positive
	_raw_points.append(point)

	line.clear_points()
	var offset_x := -max(_raw_points[-1].x - positive_width, 0)
	_offset_y_axis = Vector2(offset_x, 0)
	for i in range(_raw_points.size() - 1, -1, -1):
		var current_pos := _raw_points[i]
		var new_pos := current_pos + _offset_y_axis
		if new_pos.x >= -negative_width:
			line.add_point(new_pos)
		else:
			_raw_points.remove(i)


func _draw() -> void:
	_draw_axis()


func _draw_axis() -> void:
	# x-axis
	var left_pos := Vector2(-negative_width, 0) + _offset_x_axis
	if left_pos.y >= -negative_height and left_pos.y <= positive_height:
		var right_pos := Vector2(positive_width, 0) + _offset_x_axis
		draw_line(left_pos, right_pos, Color.black, AXIS_WIDTH, IS_ANTIALISED)

	# y-axis
	var top_pos := Vector2(0, positive_height) + _offset_y_axis
	if top_pos.x >= -negative_width and top_pos.x <= positive_width:
		var bottom_pos := Vector2(0, -negative_height) + _offset_y_axis
		draw_line(top_pos, bottom_pos, Color.black, AXIS_WIDTH, IS_ANTIALISED)
