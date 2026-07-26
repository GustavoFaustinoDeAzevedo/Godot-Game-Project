extends Node
class_name EventCommand

var runner: EventRunner
var context: EventContext

#===============================================================================

func can_start() -> bool:
	return true

#===============================================================================

func start(_runner):
	runner = _runner
	context = runner.context

#===============================================================================

func update(_delta: float):
	pass

#===============================================================================

func finish():
	if runner:
		runner.next()

#===============================================================================

func cancel():
	pass
	
	
