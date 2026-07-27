extends Node
class_name GridEntity

@onready var config: EntityConfig = get_parent() as EntityConfig
@onready var grid_world: GridWorld = get_tree().get_first_node_in_group("grid_world")

#===============================================================================
# LIFECYCLE
#===============================================================================

func _ready():
	call_deferred("_register")

#===============================================================================

func _register():
	assert(grid_world != null)
	register(get_cell())

	# Registra eventos autorun quando a entidade existir
	for child in get_parent().get_children():
		if child is GridEvent:
			if child.is_autorun():
				EventScheduler.register_autorun(child)

#===============================================================================

func _exit_tree():
	if grid_world == null:
		return

	unregister(get_cell())

#===============================================================================
# REGISTRATION
#===============================================================================

func register(cell: Vector3i):
	grid_world.register_entity(
		self,
		cell
	)

	for child in get_parent().get_children():

		if child is GridEvent:

			grid_world.register_event(
				child,
				cell
			)


func unregister(cell: Vector3i):

	grid_world.unregister_entity(
		self,
		cell
	)

	for child in get_parent().get_children():

		if child is GridEvent:

			grid_world.unregister_event(
				child,
				cell
			)

#===============================================================================
# GRID
#===============================================================================

func move(
	old_cell: Vector3i,
	new_cell: Vector3i
):

	grid_world.move_entity(
		self,
		old_cell,
		new_cell
	)


func get_cell() -> Vector3i:

	return grid_world.world_to_grid(
		get_parent().global_position
	)

#===============================================================================
# ENTITY CALLBACKS
#===============================================================================

func can_enter(_entity: GridEntity) -> bool:
	return !config.blocks_movement


func on_enter(_entity: GridEntity):
	pass


func on_leave(_entity: GridEntity):
	pass


func interact(_entity: GridEntity):
	pass
