extends Node
class_name GridMover

@export var tile_size: float = 10.0
@export var move_duration: float = 0.4

@onready var grid_world: GridWorld = get_tree().get_first_node_in_group("grid_world")
@onready var body: CharacterBody3D = get_parent() as CharacterBody3D

var moving := false

var _grid_position: Vector3i
var target_grid_position: Vector3i
var target_position: Vector3

var move_speed: float


#===============================================================================

func _ready():

	assert(grid_world != null, "GridWorld não encontrado.")

	_grid_position = grid_world.world_to_grid(body.global_position)

	body.global_position = grid_world.grid_to_world(_grid_position)

	grid_world.register_entity(body, _grid_position)

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
		set_grid_position(target_grid_position)
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


func try_move_to(cell: Vector3i):
	if moving:
		return

	target_grid_position = cell
	target_position = grid_world.grid_to_world(cell)

	moving = true

#===============================================================================

func teleport(cell: Vector3i):

	grid_world.unregister_entity(
		body,
		_grid_position
	)


	_grid_position = cell
	target_grid_position = cell

	body.global_position = grid_world.grid_to_world(
		_grid_position
	)

	target_position = body.global_position

	grid_world.register_entity(
		body,
		_grid_position
	)

#===============================================================================

func get_grid_position() -> Vector3i:
	return _grid_position


func set_grid_position(cell: Vector3i):

	grid_world.unregister_entity(
		body,
		_grid_position
	)

	_grid_position = cell

	grid_world.register_entity(
		body,
		_grid_position
	)

#===============================================================================

func is_moving() -> bool:
	return moving
	
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


func finish_move():
	body.global_position = target_position
	set_grid_position(target_grid_position)

	moving = false
