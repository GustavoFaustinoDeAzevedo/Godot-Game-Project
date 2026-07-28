class_name EventContext

var runner: EventRunner
var event: GridEvent
var entity: GridEntity
var caller: GridEntity


func get_world() -> GridWorld:
	return entity.grid_world


func get_cell() -> Vector3i:
	return entity.get_cell()

#===============================================================================
# LOCAL SWITCHES
#===============================================================================

func get_local_switch(
	name: StringName,
	default_value := false
) -> bool:

	return event.get_state().get_switch(
		name,
		default_value
	)

#-------------------------------------------------------------------------------

func set_local_switch(
	name: StringName,
	value: bool
):

	event.get_state().set_switch(
		name,
		value
	)

#===============================================================================
# LOCAL VARIABLES
#===============================================================================

func get_local_variable(
	name: StringName,
	default_value = null
):

	return event.get_state().get_variable(
		name,
		default_value
	)

#-------------------------------------------------------------------------------

func set_local_variable(
	name: StringName,
	value
):

	event.get_state().set_variable(
		name,
		value
	)
