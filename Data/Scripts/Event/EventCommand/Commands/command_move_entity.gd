extends TargetCommand
class_name MoveEntityCommand

const Direction = EventEnums.Direction

@export var direction := Direction.FORWARD
@export var custom_offset := Vector3i.ZERO
@export var use_custom_offset := false

#===============================================================================

func start(_runner):

	super(_runner)

	var entity := get_target()

	if entity == null:
		finish()
		return

	var mover := entity.get_parent().get_node("GridMover") as GridMover

	if mover == null:
		finish()
		return

	var success := false

	if use_custom_offset:

		success = mover.try_move(custom_offset)

	else:

		success = mover.try_move(
			EventUtils.direction_to_offset(
				direction,
				entity
			)
		)

	if !success:
		finish()
		return

	mover.move_finished.connect(
		_on_move_finished,
		CONNECT_ONE_SHOT
	)

	mover.move_cancelled.connect(
		_on_move_finished,
		CONNECT_ONE_SHOT
	)

#===============================================================================

func _on_move_finished():

	finish()
