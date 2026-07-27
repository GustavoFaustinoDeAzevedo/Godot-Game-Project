extends EventCommand
class_name CallEventCommand

@export var target: GridEvent

#===============================================================================

func start(_runner):

	super(_runner)

	if target == null:
		finish()
		return

	target.start(
		context.caller,
		runner
	)
