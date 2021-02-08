extends KinematicBody2D

export var max_health := 100.0 # Currently unused
export var vision_radius := 100.0
export var speed := 100.0

var _velocity := Vector2.ZERO
var _is_moving_to_target := false
var _target_position := Vector2.ZERO
var _target_dir := Vector2.ZERO

onready var health := max_health # Currently unused

onready var vision_area_shape: CollisionShape2D = $VisionArea/CollisionShape2D


func _ready() -> void:
	vision_area_shape.shape.radius = vision_radius


func _physics_process(_delta: float) -> void:
	_ai()
	_velocity = move_and_slide(_velocity)


func _ai() -> void:
	if _is_moving_to_target:
		var dist := position.distance_to(_target_position)
		if dist <= 2:
			_is_moving_to_target = false
	else:
		_target_position = _get_new_target_position()
		_target_dir = position.direction_to(_target_position)
		_velocity = _target_dir * speed
		_is_moving_to_target = true


func _get_new_target_position() -> Vector2:
	var dir := Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	return position + dir * vision_radius
