extends Node

func world_to_grid(grid_map: GridMap, world: Vector3) -> Vector3i:
	return grid_map.local_to_map(
		grid_map.to_local(world)
	)

func grid_to_world(grid_map: GridMap, cell: Vector3i) -> Vector3:
	return grid_map.to_global(
		grid_map.map_to_local(cell)
	)

## Retorna o primeiro nó com determinada classe na árvore do pai, retorna null caso não encontre
func find_sibling_by_class(node_class: String):
	for child in get_parent().get_children():
		if child.is_class(node_class):
			return child

	return null

func round_to_decimals(value: float, decimals: int) -> float:
	value =  0.0 if abs(value) < 0.001 else value
	var factor = pow(10, decimals)
	return round(value * factor) / factor
