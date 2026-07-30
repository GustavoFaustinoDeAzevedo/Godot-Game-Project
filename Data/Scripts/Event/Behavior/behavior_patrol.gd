extends GridBehavior
class_name PatrolBehavior

@export var patrol: Array[PatrolPoint]
@export var loop := true

var current_index := 0
var waiting := false
var wait_timer := 0.0

#===============================================================================

func enter():

	waiting = false
	wait_timer = 0.0

#===============================================================================

func update(delta: float):

	if patrol.is_empty():
		return

	if waiting:

		wait_timer -= delta

		if wait_timer <= 0.0:

			waiting = false
			_next_point()

		return

	if navigator.is_navigating():
		return

	var point := patrol[current_index]

	if mover.get_grid_position() != point.cell:

		navigator.navigate_to(point.cell)
		return

	if point.wait_time > 0.0:

		waiting = true
		wait_timer = point.wait_time

	else:

		_next_point()

#===============================================================================

func exit():

	navigator.stop()

#===============================================================================

func _next_point():

	current_index += 1

	if current_index >= patrol.size():

		if loop:

			current_index = 0

		else:

			current_index = patrol.size() - 1
