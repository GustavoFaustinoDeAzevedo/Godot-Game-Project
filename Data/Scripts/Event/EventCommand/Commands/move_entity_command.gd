extends EventCommand
class_name MoveEntityCommand

@export var target := EventTarget.new()

@export var offset := Vector3i.ZERO

func start(_runner):

	super(_runner)

	var target_entity := target.resolve(context)

	if target_entity == null:
		finish()
		return

	var mover := target_entity.get_parent().get_node("GridMover") as GridMover

	if mover == null:
		finish()
		return

	mover.try_move(offset)

	while mover.is_moving():
		await get_tree().process_frame

	finish()
