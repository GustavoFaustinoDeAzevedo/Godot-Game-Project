extends GridBehavior
class_name ChaseBehavior

@export var target_filter: EntityFilter

const TARGET_MEMORY := &"target"

#===============================================================================

func enter():
	pass

#===============================================================================

func update(_delta):

	var target := find_target(target_filter)

	#---------------------------------------------------
	# Vejo um alvo
	#---------------------------------------------------

	if target != null:

		if sensor.has_line_of_sight(target):

			memory.remember(
				TARGET_MEMORY,
				target,
				target.get_cell()
			)

			navigator.navigate_to(
				target.get_cell()
			)

			return

	#---------------------------------------------------
	# Não vejo, mas lembro
	#---------------------------------------------------

	if memory.has(TARGET_MEMORY):

		var last_cell := memory.get_cell(TARGET_MEMORY)

		if mover.get_grid_position() == last_cell:

			runner.change_to(SearchBehavior)
			return

		navigator.navigate_to(last_cell)
		return

	#---------------------------------------------------
	# Não tenho alvo
	#---------------------------------------------------

	runner.change_to(PatrolBehavior)

#===============================================================================

func exit():

	navigator.stop()
