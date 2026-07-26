class_name EventContext

var entity: GridEntity
var event: GridEvent
var runner: EventRunner


func get_world() -> GridWorld:
	return entity.grid_world


func get_cell() -> Vector3i:
	return entity.get_cell()
	
