extends TargetCommand
class_name MovePathCommand

@export var offset: Vector3i

#===============================================================================

func start(_runner):

	super(_runner)

	var path_target := get_target()

	if path_target == null:
		finish()
		return

	var navigator = target.get_navigator()

	if navigator == null:
		finish()
		return

	var success = navigator.move_by(offset)

	if !success:
		finish()
		return

	navigator.navigation_finished.connect(
		_on_navigation_finished,
		CONNECT_ONE_SHOT
	)

	navigator.navigation_cancelled.connect(
		_on_navigation_finished,
		CONNECT_ONE_SHOT
	)

#===============================================================================

func _on_navigation_finished():

	finish()
