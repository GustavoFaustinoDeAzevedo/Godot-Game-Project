extends EventCommand
class_name SetSwitchCommand

@export var switch_name: StringName
@export var value := true

#===============================================================================

func start(_runner):

	super(_runner)

	GameState.set_switch(
		switch_name,
		value
	)

	finish()
