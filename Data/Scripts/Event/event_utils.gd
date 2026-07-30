extends Node
class_name EventUtils

#===============================================================================

static func direction_to_offset(
	direction: int,
	entity: GridEntity
) -> Vector3i:

	var rotator := entity.get_parent().get_node("GridRotator") as GridRotator

	match direction:

		EventEnums.Direction.FORWARD:
			return rotator.forward

		EventEnums.Direction.BACK:
			return rotator.back

		EventEnums.Direction.LEFT:
			return rotator.left

		EventEnums.Direction.RIGHT:
			return rotator.right

		EventEnums.Direction.UP:
			return Vector3i.UP

		EventEnums.Direction.DOWN:
			return Vector3i.DOWN

	return Vector3i.ZERO
