extends Node
class_name EventRunner

signal finished(runner: EventRunner)

var commands: Array[EventCommand] = []

var current_index := 0
var running := false

var parent_runner: EventRunner = null
var context: EventContext

#===============================================================================

func collect_commands():

	commands.clear()

	for child in get_children():

		if child is EventCommand:
			commands.append(child)

#===============================================================================

func start(
	event: GridEvent,
	entity: GridEntity,
	caller: GridEntity,
	parent: EventRunner = null
):

	collect_commands()

	if commands.is_empty():
		return

	context = EventContext.new()

	context.runner = self
	context.event = event
	context.entity = entity
	context.caller = caller

	parent_runner = parent

	running = true
	current_index = 0

	commands[current_index].start(self)

#===============================================================================

func next():

	if !running:
		return

	current_index += 1

	if current_index >= commands.size():

		finish()
		return

	commands[current_index].start(self)

#===============================================================================

func jump(offset: int):
	jump_to(current_index + offset)

func jump_to(index: int):
	if !running:
		return

	current_index = index

	if current_index >= commands.size():
		finish()
		return

	commands[current_index].start(self)

#===============================================================================

func cancel():

	if !running:
		return

	running = false

#===============================================================================

func finish():

	if !running:
		return

	running = false

	finished.emit(self)

	if parent_runner != null:

		var runner := parent_runner
		parent_runner = null

		runner.next()

#===============================================================================

func is_running() -> bool:
	return running
