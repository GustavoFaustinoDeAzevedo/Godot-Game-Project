extends Node
class_name GridEntity

@onready var config: EntityConfig = get_parent() as EntityConfig
@onready var grid_world: GridWorld = get_tree().get_first_node_in_group("grid_world")

#===============================================================================
# LIFECYCLE
#===============================================================================

# Aguarda todos os nós da cena serem inicializados antes de registrar
# a entidade e seus eventos no GridWorld.
func _ready():
	call_deferred("_register")
	if get_parent() is not Player:
		var runner = get_parent().get_node("EventRunner") as EventRunner
		if runner != null:
			runner.start()

# Registra a entidade na célula atual e registra todos os GridEvents
# que pertencem a esta entidade.
func _register():

	assert(grid_world != null)

	register(get_cell())

# Remove a entidade e seus eventos do GridWorld quando ela sai da árvore.
func _exit_tree():

	if grid_world == null:
		return

	unregister(get_cell())

#===============================================================================
# REGISTRATION
#===============================================================================

## Adiciona a entidade ao GridWorld e registra todos os GridEvents filhos
## na célula informada.
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

## Remove a entidade e todos os seus GridEvents da célula informada.
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

## Atualiza o GridWorld quando a entidade muda de uma célula para outra.
func move(
	old_cell: Vector3i,
	new_cell: Vector3i
):

	grid_world.move_entity(
		self,
		old_cell,
		new_cell
	)

#===============================================================================
# GRID
#===============================================================================

## Retorna a célula onde esta entidade está localizada,
## convertendo sua posição no mundo para coordenadas da grid.
func get_cell() -> Vector3i:

	return grid_world.world_to_grid(
		get_parent().global_position
	)

#===============================================================================
# ENTITY CALLBACKS
#===============================================================================

## Informa se outra entidade pode entrar na mesma célula desta entidade.
func can_enter(_entity: GridEntity) -> bool:
	return !config.blocks_movement

## Chamado quando outra entidade entra na mesma célula.
func on_enter(_entity: GridEntity):
	pass

## Chamado quando outra entidade sai da mesma célula.
func on_leave(_entity: GridEntity):
	pass

## Chamado quando outra entidade interage com esta entidade.
func interact(_entity: GridEntity):
	pass
