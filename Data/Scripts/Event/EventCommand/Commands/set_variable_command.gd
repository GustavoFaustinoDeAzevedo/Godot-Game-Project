extends EventCommand
class_name SetVariableCommand

enum Operation
{
	SET,
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

@export var variable_name: StringName
@export var operation := Operation.SET
@export var value: Variant

#===============================================================================

func start(_runner):

	super(_runner)

	var current = GameState.get_variable(
		variable_name,
		0
	)

	match operation:
		Operation.SET:
			current = value

		Operation.ADD:
			current += value

		Operation.SUBTRACT:
			current -= value

		Operation.MULTIPLY:
			current *= value

		Operation.DIVIDE:
			if value != 0:
				current /= value

	GameState.set_variable(
		variable_name,
		current
	)

	finish()
