extends Node
class_name GridRotator

@export var turn_duration := 0.12

@onready var body := get_parent() as CharacterBody3D

var facing: Vector3i = Vector3i.FORWARD
var forward: Vector3i:
	get:
		return facing
var right: Vector3i:
	get:
		return Vector3i(
			-facing.z,
			0,
			facing.x
		)
var left: Vector3i:
	get:
		return -right
var back: Vector3i:
	get:
		return -facing

var turning: bool = false

var start_angle: float = 0.0
var target_angle: float = 0.0
var elapsed:float = 0.0
		
#===============================================================================

func _start_turn(direction: int):

	if turning:
		return false

	match direction:
		-1:
			facing = left

		1:
			facing = right

		2:
			facing = back

	start_angle = body.rotation.y
	target_angle = _get_angle()
	elapsed = 0.0
	turning = true

	return true

#===============================================================================

func update(delta):
	if !turning:
		return

	elapsed += delta
	var t = min(elapsed / turn_duration,1.0)
	body.rotation.y = lerp_angle(
		start_angle,
		target_angle,
		t
	)

	if t >= 1.0:
		body.rotation.y = target_angle
		turning = false

#===============================================================================

func turn_left() -> bool:
	return _start_turn(-1)


func turn_right() -> bool:
	return _start_turn(1)
	
func turn_back() -> bool:
	return _start_turn(2)
	
#===============================================================================

func _get_angle() -> float:
	match facing:
		Vector3i.FORWARD:
			return 0.0
		Vector3i.RIGHT:
			return -PI / 2
		Vector3i.BACK:
			return PI
		Vector3i.LEFT:
			return PI / 2

	return body.rotation.y

#===============================================================================

func is_turning():
	return turning
