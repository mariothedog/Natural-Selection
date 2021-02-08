extends KinematicBody2D

const AT_TARGET_THRESHOLD := 30.0

export var max_health := 100.0 # Currently unused
export var vision_radius := 200.0
export var speed := 200.0

var _velocity := Vector2.ZERO
var _is_moving_to_target := false
var _target_position := Vector2.ZERO

onready var health := max_health # Currently unused

onready var vision_area_shape: CollisionShape2D = $VisionArea/CollisionShape2D
onready var space_state := get_world_2d().direct_space_state


func _ready() -> void:
	vision_area_shape.shape.radius = vision_radius


func _physics_process(_delta) -> void:
	_ai()
	update()
	_velocity = move_and_slide(_velocity)


func _ai() -> void:
	if _is_moving_to_target:
		_velocity = position.direction_to(_target_position) * speed
		var dist := position.distance_to(_target_position)
		if dist <= AT_TARGET_THRESHOLD:
			_velocity = Vector2.ZERO
			_is_moving_to_target = false
	else:
		var is_target_safe := false
		while not is_target_safe:
			_target_position = _get_new_target_position()
			var obstacles: Dictionary = space_state.intersect_ray(position, _target_position, [], 1)
			is_target_safe = not obstacles
		
		_is_moving_to_target = true


func _get_new_target_position() -> Vector2:
	var dir := Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	return position + dir * vision_radius


func _draw() -> void:
	draw_line(Vector2.ZERO, _target_position - position, Color.red, 4)
