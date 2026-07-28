extends TargetCommand
class_name MoveEntityCommand


@export var offset := Vector3i.ZERO


func start(_runner):

	super(_runner)

	var entities := get_targets()

	for entity in entities:

		var mover := entity.get_parent().get_node("GridMover")

		mover.try_move(offset)

	finish()
