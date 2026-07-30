extends GridBehavior
class_name WanderBehavior

@export var radius := 5
@export var wait_time := 1.0

var waiting := false
var timer := 0.0

#===============================================================================

func enter():

	waiting = false
	timer = 0.0

#===============================================================================

func update(delta: float):

	if waiting:

		timer -= delta

		if timer <= 0.0:

			waiting = false

		return

	if navigator.is_navigating():
		return

	var target = sensor.random_walkable_cell(radius)

	if target == null:
		return

	navigator.navigate_to(target)

	waiting = true
	timer = wait_time

#===============================================================================

func exit():
	navigator.stop()
