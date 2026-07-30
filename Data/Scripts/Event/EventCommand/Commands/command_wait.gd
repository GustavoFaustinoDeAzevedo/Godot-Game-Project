extends EventCommand
class_name WaitCommand

@export var time := 1.0

var elapsed := 0.0


#===============================================================================

func start(_runner):

	super(_runner)

	elapsed = 0.0

#===============================================================================

func update(delta):

	elapsed += delta

	if elapsed >= time:
		finish()
