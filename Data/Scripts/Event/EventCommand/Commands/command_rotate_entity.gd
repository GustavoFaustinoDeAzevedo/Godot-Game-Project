extends TargetCommand
class_name RotateEntityCommand

const Direction = EventEnums.Direction

@export var direction := Direction.RIGHT

#===============================================================================

func start(_runner):

	super(_runner)

	var entity := get_target()

	if entity == null:
		finish()
		return

	var rotator := entity.get_parent().get_node("GridRotator") as GridRotator

	if rotator == null:
		finish()
		return

	var success := false

	match direction:

		Direction.LEFT:
			success = rotator.turn_left()

		Direction.RIGHT:
			success = rotator.turn_right()

		Direction.BACK:
			success = rotator.turn_back()

		_:
			success = false

	if !success:
		finish()
		return

	rotator.turn_finished.connect(
		_on_turn_finished,
		CONNECT_ONE_SHOT
	)

	rotator.turn_cancelled.connect(
		_on_turn_finished,
		CONNECT_ONE_SHOT
	)

#===============================================================================

func _on_turn_finished():

	finish()
