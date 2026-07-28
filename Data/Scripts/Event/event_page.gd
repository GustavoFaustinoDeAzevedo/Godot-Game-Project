extends Node
class_name EventPage

@export_group("Event")

@export var enabled := true
@export var trigger_mode := EntityConfig.TriggerMode.ENTER

@onready var conditions: EventConditions = $EventConditions
@onready var runner: EventRunner = $EventRunner

#===============================================================================

func is_enabled() -> bool:
	return enabled

#===============================================================================

func get_runner() -> EventRunner:
	return runner

#===============================================================================

func get_trigger_mode() -> EntityConfig.TriggerMode:
	return trigger_mode

#===============================================================================

func is_valid(event: GridEvent) -> bool:

	if !enabled:
		return false

	if conditions == null:
		return true

	return conditions.is_valid(event)

#===============================================================================

func can_execute(_caller: GridEntity) -> bool:
	return runner.can_start()
