extends Node
class_name GridMover

@export var tile_size: float = 10.0
@export var move_duration: float = 0.4
@export var grid_map: GridMap

@onready var body: CharacterBody3D = get_parent() as CharacterBody3D

var moving := false

var _grid_position: Vector3i
var target_grid_position: Vector3i
var target_position: Vector3

var move_speed: float


#===============================================================================

func _ready():

	_grid_position = Utils.world_to_grid(
		grid_map,
		body.global_position
	)

	body.global_position = Utils.grid_to_world(
		grid_map,
		_grid_position
	)

	move_speed = tile_size / move_duration


#===============================================================================

func update(delta: float):
	if !moving:
		return

	var remaining := target_position - body.global_position
	var distance := remaining.length()

	# Chegou ao centro do tile
	if distance <= 0.001:

		body.global_position = target_position
		_grid_position = target_grid_position

		moving = false
		return

	var step: float = min(move_speed * delta, distance)

	var collision: KinematicCollision3D = body.move_and_collide(
		remaining.normalized() * step
	)

	if collision:
		resolve_collision(collision)

		return


#===============================================================================

func try_move(direction: Vector3i):

	if moving:
		return

	try_move_to(_grid_position + direction)

#===============================================================================

func try_move_to(cell: Vector3i):

	if moving:
		return

	target_grid_position = cell

	target_position = Utils.grid_to_world(
		grid_map,
		target_grid_position
	)

	moving = true

#===============================================================================

func teleport(cell: Vector3i):

	moving = false

	_grid_position = cell
	target_grid_position = cell

	body.global_position = Utils.grid_to_world(
		grid_map,
		cell
	)

	target_position = body.global_position

#===============================================================================

func get_grid_position() -> Vector3i:
	return _grid_position

#===============================================================================

func is_moving() -> bool:
	return moving
	
#===============================================================================	

func resolve_collision(_collision: KinematicCollision3D):
	body.global_position = Utils.grid_to_world(
		grid_map,
		_grid_position
	)

	moving = false
	
#===============================================================================

func cancel_move():
	body.global_position = Utils.grid_to_world(
		grid_map,
		_grid_position
	)

	moving = false
	
#===============================================================================

func finish_move():
	body.global_position = target_position
	_grid_position = target_grid_position

	moving = false
