class_name Services

static func grid_world() -> GridWorld:
	return get_tree().get_first_node_in_group("grid_world") as GridWorld
