extends GridBehavior
class_name SearchBehavior

@export var target_filter: EntityFilter
@export var search_time := 4.0

const TARGET_MEMORY := &"target"

var timer := 0.0

#===============================================================================

func enter():

	timer = search_time

#===============================================================================

func update(delta: float):

	timer -= delta

	#---------------------------------------------------
	# Procura novamente pelo alvo
	#---------------------------------------------------

	var target := find_target(target_filter)

	if target != null:

		if sensor.has_line_of_sight(target):

			runner.change_to(ChaseBehavior)
			return

	#---------------------------------------------------
	# Não há memória
	#---------------------------------------------------

	if !memory.has(TARGET_MEMORY):

		runner.change_to(PatrolBehavior)
		return

	#---------------------------------------------------
	# Vai até a última posição conhecida
	#---------------------------------------------------

	var last_cell := memory.get_cell(TARGET_MEMORY)

	if mover.get_grid_position() != last_cell:

		navigator.navigate_to(last_cell)

	#---------------------------------------------------
	# Acabou o tempo
	#---------------------------------------------------

	if timer <= 0.0:

		memory.forget(TARGET_MEMORY)

		runner.change_to(PatrolBehavior)

#===============================================================================

func exit():

	navigator.stop()
