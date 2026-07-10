extends Node

var current_state : Node = null

func _ready():
	change_state($Idle)  # começa parado

func change_state(new_state: Node):
	#if current_state:
		#current_state.exit()
	current_state = new_state
	#current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)
