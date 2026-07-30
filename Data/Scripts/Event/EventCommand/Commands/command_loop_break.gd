extends EventCommand
class_name BreakCommand

@export var loop_end: LoopEndCommand

#===============================================================================

func start(_runner):

	super(_runner)

	if loop_end == null:
		finish()
		return

	runner.jump_to_command(loop_end)
