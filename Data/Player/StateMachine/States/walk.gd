extends Node

var machine

func _ready():
	machine = get_parent()

func enter():
	print("Entrou no estado Walk")

func update(_delta):
	var _player = machine.get_parent()

	if Utils.movement_input_vector == Vector2i.ZERO:
		machine.change_state(machine.get_node("Idle"))
		return
	if Input.is_action_just_pressed("ui_accept"):
		machine.change_state(machine.get_node("Jump"))
	elif !Input.is_action_pressed("ui_up"):
		machine.change_state(machine.get_node("Idle"))

func exit():
	print("Saiu do estado Walk")
