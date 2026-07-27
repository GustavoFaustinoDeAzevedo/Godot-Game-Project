extends EventCommand
class_name ElseCommand

@export var end_if: EndIfCommand

#===============================================================================

func start(_runner):

	super(_runner)

	if end_if == null:
		finish()
		return

	var index := runner.commands.find(end_if)

	if index == -1:
		finish()
		return

	runner.jump_to(index)
