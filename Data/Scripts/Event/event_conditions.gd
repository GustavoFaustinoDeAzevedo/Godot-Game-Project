extends Node
class_name EventConditions

const Comparison = EventEnums.Comparison

#===============================================================================
# SWITCH
#===============================================================================

@export_group("Switch")

@export var use_switch := false
@export var switch_name: StringName
@export var switch_value := true

#-------------------------------------------------------------------------------

@export_group("Local Switch")

@export var use_local_switch := false
@export var local_switch_name: StringName
@export var local_switch_value := true

#===============================================================================
# VARIABLE
#===============================================================================

@export_group("Variable")

@export var use_variable := false
@export var variable_name: StringName
@export var comparison := Comparison.EQUAL
@export var variable_value: Variant

#-------------------------------------------------------------------------------

@export_group("Local Variable")

@export var use_local_variable := false
@export var local_variable_name: StringName
@export var local_comparison := Comparison.EQUAL
@export var local_variable_value: Variant

#===============================================================================

func is_valid(event: GridEvent) -> bool:
	if use_switch:
		if GameState.get_switch(switch_name) != switch_value:
			return false

	#----------------------------------------------------------------------------

	if use_local_switch:
		if (
			event
			.get_state()
			.get_switch(local_switch_name)
			!= local_switch_value
		):
			return false

	#----------------------------------------------------------------------------

	if use_variable:
		var current = GameState.get_variable(variable_name)
		if !EventComparison.compare(
			current,
			variable_value,
			comparison
		):
			return false

	#----------------------------------------------------------------------------

	if use_local_variable:
		var current = event.get_state().get_variable(local_variable_name)
		if !EventComparison.compare(
			current,
			local_variable_value,
			local_comparison
		):
			return false

	return true
