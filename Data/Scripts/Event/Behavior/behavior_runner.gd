extends Node
class_name BehaviorRunner

@export var initial_behavior: GridBehavior

var current: GridBehavior

#===============================================================================

func _ready():

	if initial_behavior != null:

		change(initial_behavior)
		return

	for child in get_children():

		if child is GridBehavior:

			change(child)
			return

#===============================================================================

func update(delta: float):

	if current == null:
		return

	current.update(delta)

#===============================================================================

func change(next: GridBehavior):

	if next == null:
		return

	if next == current:
		return

	if current != null:
		current.exit()

	current = next
	current.runner = self
	current.enter()

#===============================================================================

func change_to(type: GDScript):

	for child in get_children():

		if !(child is GridBehavior):
			continue

		if child.get_script() == type:

			change(child)
			return

#===============================================================================

func get_current() -> GridBehavior:
	return current
