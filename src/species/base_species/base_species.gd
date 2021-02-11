extends KinematicBody2D

signal dead(organism)
signal baby_wanted(parent)

const AT_TARGET_THRESHOLD := 30.0
const HEALTH_LOSS_RATE := 20.0  # Health lost/second
const REPRODUCTIVE_CHANCE := 0.1  # Chance each second

var phenotypes := {
	max_health = 100.0,
	vision_radius = 200.0,
	speed = 200.0,
}

var health: float = phenotypes.max_health

var _velocity := Vector2.ZERO
var _is_moving_to_target := false
var _target_position := Vector2.ZERO
var _food_in_range := []  # Each food's global position ordered in ascending distance

var _target_position_rng := Rand.get_new_random_generator()

onready var space_state := get_world_2d().direct_space_state


func _ready() -> void:
	$FoodDetector/CollisionShape2D.shape.radius = phenotypes.vision_radius


func _physics_process(delta: float) -> void:
	_ai()
	_velocity = move_and_slide(_velocity)

	hurt(HEALTH_LOSS_RATE * delta)


func hurt(damage: float) -> void:
	health -= damage
	if health <= 0:
		health = 0
		die()


func die() -> void:
	emit_signal("dead", self)
	queue_free()


func _on_CreateBaby_timeout() -> void:
	if randf() < REPRODUCTIVE_CHANCE:
		emit_signal("baby_wanted", self)


func _ai() -> void:
	if _is_moving_to_target:
		_velocity = position.direction_to(_target_position) * phenotypes.speed
		var dist := position.distance_to(_target_position)
		if dist <= AT_TARGET_THRESHOLD:
			_velocity = Vector2.ZERO
			_is_moving_to_target = false
		return

	if _food_in_range:
		_target_position = _food_in_range[0]
	else:
		var is_target_safe := false
		while not is_target_safe:
			_target_position = _get_new_target_position()
			var obstacles: Dictionary = space_state.intersect_ray(position, _target_position, [], 1)
			is_target_safe = not obstacles
	_is_moving_to_target = true


func _get_new_target_position() -> Vector2:
	var dir := Vector2(_target_position_rng.randf_range(-1, 1), _target_position_rng.randf_range(-1, 1)).normalized()
	return position + dir * phenotypes.vision_radius


func _on_FoodDetector_area_entered(area: Area2D) -> void:
	_food_in_range.append(area.global_position)
	_food_in_range.sort_custom(self, "_sort_closest_vector2")


func _on_FoodDetector_area_exited(area: Area2D) -> void:
	_food_in_range.erase(area.global_position)


func _sort_closest_vector2(a: Vector2, b: Vector2) -> bool:
	return global_position.distance_to(a) < global_position.distance_to(b)


func _on_Mouth_area_entered(area: Area2D) -> void:
	area.die()
	health = phenotypes.max_health
