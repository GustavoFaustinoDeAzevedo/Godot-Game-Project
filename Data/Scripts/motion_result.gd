class_name MotionResult
extends RefCounted

var can_move: bool = false
var collision: bool = false

var collision_point: Vector3 = Vector3.ZERO
var collision_normal: Vector3 = Vector3.ZERO
var travel: Vector3 = Vector3.ZERO
var remainder: Vector3 = Vector3.ZERO
