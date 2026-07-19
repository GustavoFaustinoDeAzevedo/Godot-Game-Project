extends Node

var movement_input_vector: Vector2i ## (x, y); 1/-1 -> x = Esquerda/Direita; y = Norte/Sul 
var is_turn_direction_input = Input.is_action_just_pressed('turn_left') or Input.is_action_just_pressed('turn_right')

func _process(_delta) -> void:
	movement_input_vector = Input.get_vector("move_left","move_right","move_forward","move_back")

func world_to_grid(grid_map: GridMap, world: Vector3) -> Vector3i:
	return grid_map.local_to_map(
		grid_map.to_local(world)
	)


func grid_to_world(grid_map: GridMap, cell: Vector3i) -> Vector3:
	return grid_map.to_global(
		grid_map.map_to_local(cell)
	)

func round_to_decimals(value: float, decimals: int) -> float:
	value =  0.0 if abs(value) < 0.001 else value
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func get_orientation(facing_direction: int) -> Vector3i:
	match facing_direction:
		0: return Vector3i.FORWARD
		1: return Vector3i.LEFT
		2: return Vector3i.BACK
		3: return Vector3i.RIGHT
	return Vector3i.ZERO

func is_aligned(grid_map: GridMap, pos: Vector3) -> bool:
	var cell = grid_map.local_to_map(pos)
	var center = grid_map.map_to_local(cell)
	return pos.x == center.x and pos.z == center.z
	
func snap_to_gridmap(grid_map: GridMap, pos: Vector3) -> Vector3:
	var cell = grid_map.local_to_map(pos)
	return grid_map.map_to_local(cell)
