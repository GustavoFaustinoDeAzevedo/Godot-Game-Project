extends Node
class_name StateMachine

@export var initial_state: StateBase

var character: Node
var current_state: StateBase

var states: Dictionary[StringName, StateBase] = {}

#===============================================================================

func _ready() -> void:

	character = get_parent()
	assert(character != null, "StateMachine precisa ser filha do objeto controlado.")

	for child in get_children():
		if child is StateBase:
			states[child.name] = child

	if initial_state:
		change_state(initial_state, {})

#===============================================================================

func _process(delta):
	if current_state:
		current_state.update(delta)

#===============================================================================

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
		
#===============================================================================

func _unhandled_input(event):
	if current_state:
		current_state.handle_input(event)

#===============================================================================

func get_state(stateName: StringName) -> StateBase:
	return states.get(stateName)

#===============================================================================

func change_state(state: StateBase, data = {}) -> void:
	if state == null:
		push_warning("Estado inexistente.")
		return

	if current_state == state:
		return

	if current_state:
		current_state.exit()

	current_state = state
	current_state.state_machine = self
	current_state.character = character
	current_state.enter(data)

#===============================================================================

func change_state_by_name(stateName: StringName, data) -> void:
	change_state(get_state(stateName), data)
