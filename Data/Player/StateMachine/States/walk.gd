extends PlayerState

func enter(_data):
	player.mover.try_move(
		player.rotator.forward
	)


func physics_update(delta):
	player.mover.update(delta)
	if !player.mover.is_moving():
		change_state(&"Idle")
