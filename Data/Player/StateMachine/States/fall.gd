class_name FallState
extends PlayerState
#
#func enter(_previous_state: PlayerState) -> void:
	#print('actual state: fall', ' previous_state: ', _previous_state)
#
#func physics_update(_delta: float) -> void:
	#player.velocity += player.get_gravity()*_delta
	#if player.global_position.y <= player.MIN_HEIGHT*player.TILE_SIZE:
		#player.redo_movement()
	#player.move_and_slide()
	#if player.is_on_floor():
		#state_machine.change_state(state_machine.get_node("Idle"))
