extends TargetCommand
class_name StopNavigationCommand

func start(_runner):

	super(_runner)

	var entity := get_target()

	if entity == null:
		finish()
		return

	var navigator := entity.get_navigator()

	if navigator != null:
		navigator.stop()

	finish()
