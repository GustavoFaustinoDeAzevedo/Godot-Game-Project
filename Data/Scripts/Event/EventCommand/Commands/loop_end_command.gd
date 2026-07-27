extends EventCommand
class_name LoopEndCommand

@export var loop_begin: LoopBeginCommand

#===============================================================================

func start(_runner):

	super(_runner)

	if loop_begin == null:
		finish()
		return

	runner.jump_to_command(loop_begin)
