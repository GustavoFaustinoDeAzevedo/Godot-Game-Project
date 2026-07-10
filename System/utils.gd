extends Node

var movement_input_vector: Vector2i ## (x, y); 1/-1 -> x = Esquerda/Direita; y = Norte/Sul 
var is_turn_direction_input = Input.is_action_just_pressed('turn_left') or Input.is_action_just_pressed('turn_right')

func _process(_delta) -> void:
	movement_input_vector = Input.get_vector("move_left","move_right","move_up","move_down")

func global_to_grid(grid_map: GridMap, coord: Vector3):
	if coord:
		var local: Vector3 = grid_map.to_local(coord)
		local = Vector3(
				round_to_decimals(local.x, 2),
				round_to_decimals(local.y, 2),
				round_to_decimals(local.z, 2)
			)
		return grid_map.local_to_map(local)
	return coord
	
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
