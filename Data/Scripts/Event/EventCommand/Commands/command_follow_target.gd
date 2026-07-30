extends TargetCommand
class_name FollowTargetCommand

@export var destination := EventTarget.new()

@export var distance := 0

#===============================================================================

func start(_runner):

	super(_runner)

	var entity := get_target()

	if entity == null:
		finish()
		return

	var navigator := entity.get_navigator()

	if navigator == null:
		finish()
		return

	var target := destination.resolve(context)

	if target == null:
		finish()
		return

	navigator.follow_target(
		target,
		distance
	)
