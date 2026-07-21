extends Node
class_name GridObject

@onready var grid_map: GridMap = get_parent()

var grid_position: Vector3i


func initialize(_world_position: Vector3):

	grid_position = Utils.world_to_grid(
		grid_map,
		_world_position
	)


func world_position() -> Vector3:
	return Utils.grid_to_world(
		grid_map,
		grid_position
	)
