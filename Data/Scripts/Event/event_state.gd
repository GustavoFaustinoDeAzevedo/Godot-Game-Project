extends RefCounted
class_name EventState

var switches: Dictionary = {}
var variables: Dictionary = {}

#===============================================================================
# SWITCHES
#===============================================================================

func has_switch(name: StringName) -> bool:
	return switches.has(name)

#-------------------------------------------------------------------------------

func get_switch(
	name: StringName,
	default_value := false
) -> bool:

	return switches.get(
		name,
		default_value
	)

#-------------------------------------------------------------------------------

func set_switch(
	name: StringName,
	value: bool
):

	switches[name] = value

#-------------------------------------------------------------------------------

func erase_switch(name: StringName):

	switches.erase(name)

#===============================================================================
# VARIABLES
#===============================================================================

func has_variable(name: StringName) -> bool:
	return variables.has(name)

#-------------------------------------------------------------------------------

func get_variable(
	name: StringName,
	default_value = null
):

	return variables.get(
		name,
		default_value
	)

#-------------------------------------------------------------------------------

func set_variable(
	name: StringName,
	value
):

	variables[name] = value

#-------------------------------------------------------------------------------

func erase_variable(name: StringName):

	variables.erase(name)

#===============================================================================

func clear():

	switches.clear()
	variables.clear()
