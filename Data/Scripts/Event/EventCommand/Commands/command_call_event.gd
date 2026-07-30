extends EventCommand
class_name CallEventCommand

@export var event: GridEvent

#===============================================================================

func start(_runner):

	super(_runner)

	if event == null:
		finish()
		return

	event.start(
		context.caller,
		runner
	)
