extends Node
class_name GridInteractor

@onready var grid_world: GridWorld = get_tree().get_first_node_in_group("grid_world")
@onready var mover: GridMover = $"../GridMover"
@onready var rotator: GridRotator = $"../GridRotator"
@onready var entity: GridEntity = $"../GridEntity"

#===============================================================================

func interact():

	var target_cell := mover.get_grid_position() + rotator.forward

	grid_world.notify_entity_interacted(
		entity,
		target_cell
	)
