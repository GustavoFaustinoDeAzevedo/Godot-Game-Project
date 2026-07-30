extends Node
class_name MoveRoute

@onready var runner: EventRunner = $EventRunner

#===============================================================================

func _ready():

	assert(runner != null)

#===============================================================================

func get_runner() -> EventRunner:
	return runner
