extends EventCommand
class_name TargetCommand

@export var target := EventTarget.new()


func get_target() -> GridEntity:

	return target.resolve(context)


func get_targets() -> Array[GridEntity]:

	return target.resolve_all(context)
