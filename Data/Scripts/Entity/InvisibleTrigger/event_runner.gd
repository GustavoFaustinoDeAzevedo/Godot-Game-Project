extends Node
class_name EventRunner

var commands: Array[EventCommand] = []
var current_command: EventCommand

var current_index := 0
var running := false


#===============================================================================

func collect_commands():

	commands.clear()

	for child in get_children():

		if child is EventCommand:
			commands.append(child)

#===============================================================================

func start():

	if running:
		return

	collect_commands()

	if commands.is_empty():
		return

	running = true
	current_index = 0

	current_command = commands[current_index]
	current_command.start(self)
	
#===============================================================================

func _process(delta):

	if !running:
		return

	current_command = commands[current_index]
	current_command.update(delta)

#===============================================================================

func next():

	if !running:
		return

	current_index += 1

	if current_index >= commands.size():

		finish()
		return

	current_command = commands[current_index]
	current_command.start(self)


#===============================================================================

func finish():

	running = false

#===============================================================================

func is_running() -> bool:
	return running
