extends EventCommand
class_name ConditionalCommand


const ConditionType = EventEnums.ConditionType
const Comparison = EventEnums.Comparison

@export var condition := ConditionType.SWITCH

@export_group("Switch")
@export var switch_name: StringName
@export var switch_value := true

@export_group("Variable")
@export var variable_name: StringName
@export var comparison := Comparison.EQUAL
@export var variable_value: Variant

## Quantos comandos devem ser pulados caso a condição seja falsa.
@export var false_target: EventCommand

#===============================================================================

func start(_runner):

	super(_runner)

	var result := false

	match condition:

		ConditionType.SWITCH:

			result = (
				GameState.get_switch(switch_name)
				== switch_value
			)

		ConditionType.VARIABLE:

			var current = GameState.get_variable(variable_name)

			match comparison:

				Comparison.EQUAL:
					result = current == variable_value

				Comparison.NOT_EQUAL:
					result = current != variable_value

				Comparison.GREATER:
					result = current > variable_value

				Comparison.GREATER_EQUAL:
					result = current >= variable_value

				Comparison.LESS:
					result = current < variable_value

				Comparison.LESS_EQUAL:
					result = current <= variable_value

	if result:

		finish()

	else:

		if false_target == null:
			finish()
			return

		var index := runner.commands.find(false_target)

		if index == -1:
			finish()
			return

		runner.jump_to(index)
