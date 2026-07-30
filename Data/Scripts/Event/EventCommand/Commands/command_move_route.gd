extends TargetCommand
class_name MoveRouteCommand

@export var route: MoveRoute

#===============================================================================

func start(_runner):

	super(_runner)

	if route == null:
		finish()
		return

	var route_target = get_target()

	if route_target == null:
		finish()
		return

	var route_runner := route.get_runner()

	if route_runner.is_running():
		finish()
		return

	route_runner.finished.connect(
		_on_route_finished,
		CONNECT_ONE_SHOT
	)

	route_runner.start(
		context.event,
		route_target,
		context.caller,
		runner
	)

#===============================================================================

func _on_route_finished(_route_runner: EventRunner):
	finish()
