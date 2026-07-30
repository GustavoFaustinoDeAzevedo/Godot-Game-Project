extends Node
class_name GridBehavior

@onready var entity: GridEntity = $"../GridEntity"
@onready var sensor: GridSensor = $"../GridSensor"
@onready var mover: GridMover = $"../GridMover"
@onready var navigator: GridNavigator = $"../GridNavigator"
@onready var memory: GridMemory = $"../GridMemory"

var runner: BehaviorRunner

#===============================================================================

func _ready():
	assert(memory != null)
	assert(entity != null)
	assert(sensor != null)
	assert(mover != null)
	assert(navigator != null)

#===============================================================================

func enter():
	pass

#===============================================================================

func exit():
	pass

#===============================================================================

func update(_delta: float):
	pass

#===============================================================================

func find_target(filter: EntityFilter) -> GridEntity:

	var target := sensor.nearest_entity(filter)

	if target == null:
		return null

	if !sensor.has_line_of_sight(target):
		return null

	return target
