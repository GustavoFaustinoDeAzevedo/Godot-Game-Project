extends Node
class_name GridNavigator

signal navigation_started
signal navigation_finished
signal navigation_cancelled

@onready var mover: GridMover = $"../GridMover"
@onready var entity: GridEntity = $"../GridEntity"
@onready var world: GridWorld = get_tree().get_first_node_in_group("grid_world")

var path: Array[Vector3i] = []
var navigating := false
var follow_entity: GridEntity
var follow_distance := 0
var following := false

#===============================================================================

func _ready():

	assert(mover != null)
	assert(entity != null)
	assert(world != null)

	mover.move_finished.connect(_on_step_finished)
	mover.move_cancelled.connect(_on_navigation_cancelled)


func _process(_delta):

	if !following:
		return

	if navigating:
		return

	_update_follow()

#===============================================================================

func move_by(offset: Vector3i) -> bool:

	return follow(
		world.build_path(
			entity.get_cell(),
			offset
		)
	)


func move_to(cell: Vector3i) -> bool:
	var navigator_path := world.build_path(entity.get_cell(), cell)

	return follow(navigator_path)

#===============================================================================

func follow(new_path: Array[Vector3i]) -> bool:

	if navigating:
		return false

	if new_path.is_empty():
		return false

	if !world.request_path(entity, new_path):
		return false

	path = new_path.duplicate()
	navigating = true
	navigation_started.emit()
	_start_next_step()

	return true
	
func follow_target(target: GridEntity, distance := 0) -> bool:

	if target == null:
		return false

	follow_entity = target
	follow_distance = distance
	following = true

	_update_follow()

	return true

func _update_follow():

	if follow_entity == null:

		stop_follow()
		return

	var current := entity.get_cell()
	var target = follow_entity.get_cell()

	if current.distance_to(target) <= follow_distance:
		return

	move_to(target)
	
#===============================================================================

func stop():

	if !navigating:
		return

	path.clear()

	navigating = false

	mover.cancel_move()

	navigation_cancelled.emit()

func stop_follow():

	following = false
	follow_entity = null

	stop()
	
#===============================================================================

func _start_next_step():

	if path.is_empty():

		navigating = false

		navigation_finished.emit()

		return

	var next_cell = path.pop_front()

	mover.move_to(next_cell)

#===============================================================================

func _on_step_finished():

	if !navigating:
		return

	_start_next_step()

#===============================================================================

func _on_navigation_cancelled():

	if !navigating:
		return

	path.clear()

	navigating = false

	navigation_cancelled.emit()

#===============================================================================

func is_navigating() -> bool:
	return navigating
