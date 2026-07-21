extends Node
class_name GridWorld

@export var grid_map: GridMap

var entities: Dictionary = {}

#===============================================================================

func register_entity(entity: Node, cell: Vector3i):
	if !entities.has(cell):
		entities[cell] = []

	entities[cell].append(entity)
	
func unregister_entity(entity: Node, cell: Vector3i):
	if !entities.has(cell):
		return
	entities[cell].erase(entity)
	
	if entities[cell].is_empty():
		entities.erase(cell)

func get_entities(cell: Vector3i) -> Array:
	return entities.get(cell, [])
	
func is_occupied(cell: Vector3i):
	return entities.has(cell)

#===============================================================================

func world_to_grid(position: Vector3) -> Vector3i:
	return Utils.world_to_grid(
		grid_map,
		position
	)

func grid_to_world(cell: Vector3i) -> Vector3:
	return Utils.grid_to_world(
		grid_map,
		cell
	)
	
#===============================================================================
