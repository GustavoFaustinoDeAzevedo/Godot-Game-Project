extends EventCommand
class_name PrintCommand

@export var dialogue: DialogueResource
var title = 'start'

#===============================================================================

func start(_runner):
	super(_runner)
	DialogueManager.show_dialogue_balloon(
		dialogue,
		title
	)
	await DialogueManager.dialogue_ended
	finish()
