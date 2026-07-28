extends Resource
class_name EventTarget

const TargetType = EventEnums.TargetType

@export var target_type := TargetType.SELF

@export_group("Group")
@export var group_name: StringName

#===============================================================================

func resolve(context: EventContext) -> GridEntity:

	var targets := resolve_all(context)

	if targets.is_empty():
		return null

	return targets[0]

#===============================================================================

func resolve_all(context: EventContext) -> Array[GridEntity]:

	match target_type:

		TargetType.SELF:
			return [context.entity]

		TargetType.CALLER:

			if context.caller == null:
				return []

			return [context.caller]

		TargetType.PLAYER:

			var player := context.get_world().get_player()

			if player == null:
				return []

			return [player]

		TargetType.GROUP:

			return context.get_world().get_entities_by_group(
				group_name
			)

	return []
