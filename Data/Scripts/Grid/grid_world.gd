extends Node
class_name GridWorld

@export var grid_map: GridMap


var entities: Dictionary = {}
var events: Dictionary = {}
var current_autorun: GridEvent
var autorun_events: Array[GridEvent] = []
var parallel_events: Array[GridEvent] = []
var cells: Dictionary[Vector3i, GridCell] = {}


#===============================================================================
# INTERNAL
#===============================================================================

## Adiciona um objeto a um dicionário indexado por célula.
## Caso a célula ainda não exista, ela é criada.
func _add(dictionary: Dictionary, key: Vector3i, value: Object):

	if !dictionary.has(key):
		dictionary[key] = []

	dictionary[key].append(value)

## Remove um objeto de uma célula.
## Se a célula ficar vazia, ela é removida do dicionário.
func _remove(dictionary: Dictionary, key: Vector3i, value: Object):
	if !dictionary.has(key):
		return
	dictionary[key].erase(value)
	if dictionary[key].is_empty():
		dictionary.erase(key)

func _process(delta):
	_process_parallel(delta)
	_process_autorun()
	
func _process_parallel(delta):
	for event in parallel_events:
		if !event.can_execute(null):
			continue

		event.parallel_process(delta)

func _process_autorun():
	if current_autorun != null:
		if current_autorun.is_finished():
			current_autorun = null

		return

	for event in autorun_events:
		if !event.can_execute(null):
			continue
		current_autorun = event
		event.execute(null)

		break

#===============================================================================
# COORDINATES
#===============================================================================

## Converte uma posição no mundo para uma célula da GridMap.
func world_to_grid(position: Vector3) -> Vector3i:

	return Utils.world_to_grid(
		grid_map,
		position
	)

## Converte uma célula da GridMap para sua posição no mundo.
func grid_to_world(cell: Vector3i) -> Vector3:

	return Utils.grid_to_world(
		grid_map,
		cell
	)

#===============================================================================
# ENTITIES
#===============================================================================

## Registra uma entidade em determinada célula.
func register_entity(
	entity: GridEntity,
	cell: Vector3i
):

	_add(
		entities,
		cell,
		entity
	)

## Remove uma entidade da célula informada.
func unregister_entity(
	entity: GridEntity,
	cell: Vector3i
):

	_remove(
		entities,
		cell,
		entity
	)

## Atualiza o GridWorld quando uma entidade muda de célula.
##
## Responsabilidades:
##  mover a entidade;
##  mover todos os GridEvents;
##  disparar eventos EXIT;
##  disparar eventos ENTER;
##  disparar eventos AUTO.
func move_entity(
	entity: GridEntity,
	old_cell: Vector3i,
	new_cell: Vector3i
):

	unregister_entity(
		entity,
		old_cell
	)

	register_entity(
		entity,
		new_cell
	)

	for child in entity.get_parent().get_children():

		if child is GridEvent:

			unregister_event(
				child,
				old_cell
			)

			register_event(
				child,
				new_cell
			)

	notify_entity_left(
		entity,
		old_cell
	)

	notify_entity_entered(
		entity,
		new_cell
	)

## Retorna todas as entidades presentes na célula.
func get_entities(cell: Vector3i) -> Array:
	return entities.get(cell, [])

## Informa se existe alguma entidade ocupando a célula.
func is_occupied(cell: Vector3i) -> bool:
	return entities.has(cell)

#===============================================================================
# EVENTS
#===============================================================================

## Registra um GridEvent em determinada célula.
func register_event(
	event: GridEvent,
	cell: Vector3i
):

	_add(
		events,
		cell,
		event
	)

	var config := event.get_parent() as EntityConfig

	if config == null:
		config = event.get_parent().get_node("EntityConfig")

	if config == null:
		return

	match config.trigger_mode:

		EntityConfig.TriggerMode.AUTORUN:
			autorun_events.append(event)

		EntityConfig.TriggerMode.PARALLEL:
			parallel_events.append(event)

## Remove um GridEvent da célula.
func unregister_event(
	event: GridEvent,
	cell: Vector3i
):

	_remove(
		events,
		cell,
		event
	)

	autorun_events.erase(event)
	parallel_events.erase(event)

## Retorna todos os eventos existentes em uma célula.
func get_events(cell: Vector3i) -> Array:
	return events.get(cell, [])

## Indica se a célula possui algum evento registrado.
func has_events(cell: Vector3i) -> bool:
	return events.has(cell)

#===============================================================================
# MOVEMENT
#===============================================================================

## Pergunta ao GridWorld se uma entidade pode entrar na célula.
##
## Retorna: 
## true  -> movimento permitido;
## false -> movimento bloqueado por alguma entidade.
func request_move(
	entity: GridEntity,
	cell: Vector3i
) -> bool:

	if !is_occupied(cell):
		return true

	for other: GridEntity in get_entities(cell):

		if other == entity:
			continue

		if !other.can_enter(entity):
			return false

	return true

#===============================================================================
# EVENT DISPATCH
#===============================================================================

## Procura todos os eventos da célula e executa apenas aqueles
## compatíveis com o TriggerMode informado.
func notify(
	entity: GridEntity,
	cell: Vector3i,
	mode: EntityConfig.TriggerMode
):

	if !has_events(cell):
		return

	for event: GridEvent in get_events(cell):

		if event.trigger == null:
			continue

		if !event.trigger.enabled:
			continue

		var config := event.get_parent() as EntityConfig
		
		if config == null:
			config = event.get_parent().get_node('EntityConfig')

		if config == null:
			continue

		if config.trigger_mode != mode:
			continue

		if !event.can_execute(entity):
			continue

		event.execute(entity)

		if event.trigger.one_shot:
			event.trigger.enabled = false

## Dispara eventos configurados para ENTER.
func notify_entity_entered(entity: GridEntity, cell: Vector3i):

	notify(
		entity,
		cell,
		EntityConfig.TriggerMode.ENTER
	)

## Dispara eventos configurados para EXIT.
func notify_entity_left(entity: GridEntity, cell: Vector3i):

	notify(
		entity,
		cell,
		EntityConfig.TriggerMode.EXIT
	)

## Dispara eventos configurados para INTERACT.
func notify_entity_interacted(entity: GridEntity, cell: Vector3i):

	notify(
		entity,
		cell,
		EntityConfig.TriggerMode.INTERACT
	)

## Dispara eventos configurados para AUTO.
func notify_entity_auto(entity: GridEntity, cell: Vector3i):

	notify(
		entity,
		cell,
		EntityConfig.TriggerMode.AUTORUN
	)

## Dispara eventos configurados para MANUAL.
func notify_entity_manual(entity: GridEntity, cell: Vector3i):

	notify(
		entity,
		cell,
		EntityConfig.TriggerMode.MANUAL
	)
