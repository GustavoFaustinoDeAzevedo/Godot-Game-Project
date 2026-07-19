extends PlayerState


	
func handle_input(event):

	if event.is_action_pressed("move_forward"):

		change_state(&"Walk")

	elif event.is_action_pressed("turn_left"):

		change_state(
			&"Turn",
			{
				"direction": -1
			}
		)

	elif event.is_action_pressed("turn_right"):

		change_state(
			&"Turn",
			{
				"direction": 1
			}
		)
