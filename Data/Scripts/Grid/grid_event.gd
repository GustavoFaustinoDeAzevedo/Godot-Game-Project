extends Node
class_name GridEvent

@onready var trigger: EntityConfig = get_parent() as EntityConfig

#===============================================================================

func can_execute(_entity: GridEntity) -> bool:
	return true

func execute(_entity: GridEntity = null):
	pass
	
func parallel_process(_delta):
	pass
	
func is_finished() -> bool:
	return true
