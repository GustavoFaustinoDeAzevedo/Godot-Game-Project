extends Node
class_name EventScheduler

var current: EventRunner = null

#pra depois
enum ExecutionMode {
	EXCLUSIVE,
	PARALLEL
}

#===============================================================================

func request(runner: EventRunner, _mode = ExecutionMode.EXCLUSIVE) -> bool:

	if current != null:
		return false

	current = runner

	return true

#===============================================================================

func finish(runner: EventRunner):

	if current != runner:
		return

	current = null

#===============================================================================

func is_busy() -> bool:
	return current != null

#===============================================================================

func get_current() -> EventRunner:
	return current
