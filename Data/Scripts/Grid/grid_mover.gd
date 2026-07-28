extends Node
class_name GridMover

@export var tile_size := 10.0
@export var move_duration := 0.4

@onready var grid_world: GridWorld = get_tree().get_first_node_in_group("grid_world")
@onready var body: CharacterBody3D = get_parent() as CharacterBody3D
@onready var entity: GridEntity = $"../GridEntity"

var moving := false

var _grid_position: Vector3i
var target_grid_position: Vector3i
var target_position: Vector3
var move_offset := Vector3i.ZERO

var move_speed: float

#===============================================================================

func _ready():

	assert(grid_world != null)
	assert(entity != null)

	_grid_position = grid_world.world_to_grid(
		body.global_position
	)

	body.global_position = grid_world.grid_to_world(
		_grid_position
	)

	move_speed = tile_size / move_duration

#===============================================================================

func update(delta: float):

	if !moving:
		return

	var remaining := target_position - body.global_position

	var step = min(
		move_speed * delta,
		remaining.length()
	)

	var collision := body.move_and_collide(
		remaining.normalized() * step
	)

	if collision:
		resolve_collision(collision)
		return

	if body.global_position.distance_to(target_position) <= 0.05:
		finish_move()

#===============================================================================

func try_move(offset: Vector3i) -> bool:

	if moving:
		return false

	var path := build_path(offset)

	if path.is_empty():
		return false

	if !grid_world.request_path(entity, path):
		return false

	move_offset = offset

	move_to(path.back())

	return true
	
#===============================================================================
	
func build_path(offset: Vector3i) -> Array[Vector3i]:

	var path: Array[Vector3i] = []

	var current := _grid_position

	var remaining := offset

	while remaining != Vector3i.ZERO:

		if remaining.x != 0:

			current.x += signi(remaining.x)
			remaining.x -= signi(remaining.x)

		elif remaining.y != 0:

			current.y += signi(remaining.y)
			remaining.y -= signi(remaining.y)

		elif remaining.z != 0:

			current.z += signi(remaining.z)
			remaining.z -= signi(remaining.z)

		path.append(current)

	return path

#===============================================================================

func move_to(cell: Vector3i):

	if moving:
		return

	target_grid_position = cell
	target_position = grid_world.grid_to_world(cell)

	moving = true

#===============================================================================

func teleport(cell: Vector3i):

	entity.move(
		_grid_position,
		cell
	)

	_grid_position = cell
	target_grid_position = cell

	body.global_position = grid_world.grid_to_world(cell)
	target_position = body.global_position

#===============================================================================

func finish_move():
	
	body.global_position = target_position

	entity.move(
		_grid_position,
		target_grid_position
	)

	_grid_position = target_grid_position

	moving = false

#===============================================================================

func resolve_collision(_collision: KinematicCollision3D):

	body.global_position = grid_world.grid_to_world(
		_grid_position
	)

	moving = false

#===============================================================================

func cancel_move():

	body.global_position = grid_world.grid_to_world(
		_grid_position
	)

	moving = false

#===============================================================================

func get_grid_position() -> Vector3i:
	return _grid_position

func is_moving() -> bool:
	return moving
