extends Node
class_name EntityConfig

enum Layer {
	FLOOR,
	OBJECT,
	CHARACTER
}

enum Priority {
	BELOW,
	SAME,
	ABOVE
}

enum TriggerMode
{
	ENTER,
	EXIT,
	INTERACT,
	AUTORUN,
	PARALLEL,
	MANUAL
}


@export_group("Grid")

@export var layer := Layer.OBJECT
@export var priority := Priority.SAME
@export var blocks_movement := true


@export_group("Event")

@export var trigger_mode := TriggerMode.ENTER
@export var one_shot := false
@export var enabled := true
