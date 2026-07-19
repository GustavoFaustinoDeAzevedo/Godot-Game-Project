extends Node
class_name StateBase

var state_machine: StateMachine
var character: Node


func enter(_data):
	pass


func exit():
	pass


func handle_input(_event):
	pass


func update(_delta):
	pass


func physics_update(_delta):
	pass


func change_state(stateName: StringName, _data = {}):
	
	state_machine.change_state_by_name(stateName, _data)
