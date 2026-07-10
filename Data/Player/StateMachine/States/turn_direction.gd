extends Node

var machine

func _ready():
	machine = get_parent()

func enter():
	print("Entrou no estado Idle")

func update(_delta):
	if Utils.is_turn_direction_input:
		machine.change_state(machine.get_node("Walk"))

func exit():
	print("Saiu do estado Idle")
