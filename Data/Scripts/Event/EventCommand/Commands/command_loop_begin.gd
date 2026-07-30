extends EventCommand
class_name LoopBeginCommand

@export var loop_end: LoopEndCommand

#===============================================================================

func start(_runner):

	super(_runner)

	finish()
