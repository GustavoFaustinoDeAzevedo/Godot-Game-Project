extends PlayerState

func enter(data):
	if data.direction > 0:
		player.rotator.turn_right()
	else:
		player.rotator.turn_left()

func physics_update(delta):
	player.rotator.update(delta)
	if !player.rotator.is_turning():
		change_state(&"Idle")
