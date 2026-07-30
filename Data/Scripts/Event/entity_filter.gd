extends Resource
class_name EntityFilter

@export_group("Groups")

@export var use_group := false
@export var group_name: StringName

#-------------------------------------------------------------------------------

@export_group("Entity")

@export var ignore_self := true
@export var require_enabled := true

#===============================================================================

func matches(
	requester: GridEntity,
	candidate: GridEntity
) -> bool:

	if candidate == null:
		return false

	if ignore_self and candidate == requester:
		return false

	if use_group:

		if !candidate.is_in_group(group_name):
			return false

	if require_enabled:

		if !candidate.is_enabled():
			return false

	return true
