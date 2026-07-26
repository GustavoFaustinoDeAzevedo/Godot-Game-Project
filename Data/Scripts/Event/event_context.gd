class_name EventContext

var runner: EventRunner
var event: GridEvent
var entity: GridEntity
var caller: GridEntity


func get_world() -> GridWorld:
	return entity.grid_world


func get_cell() -> Vector3i:
	return entity.get_cell()
	
