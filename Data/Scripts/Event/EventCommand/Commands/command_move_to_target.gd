extends TargetCommand
class_name MoveToTargetCommand

@export var destination := EventTarget.new()

#===============================================================================

func start(_runner):

	super(_runner)

	var mover := get_target()

	if mover == null:
		finish()
		return

	var destination_entity := destination.resolve(context)

	if destination_entity == null:
		finish()
		return

	var navigator := mover.get_navigator()

	if navigator == null:
		finish()
		return

	var success := navigator.move_to(
		destination_entity.get_cell()
	)

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
