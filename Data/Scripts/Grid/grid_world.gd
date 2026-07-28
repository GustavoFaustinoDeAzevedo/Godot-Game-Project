extends Node
class_name GridWorld

signal entity_entered(entity: GridEntity, cell: Vector3i)
signal entity_left(entity: GridEntity, cell: Vector3i)
signal entity_interacted(entity: GridEntity, cell: Vector3i)

@export var grid_map: GridMap

var entities: Dictionary = {}
var events: Dictionary = {}

#===============================================================================
# INTERNAL
#===============================================================================

func _add(dictionary: Dictionary, key: Vector3i, value: Object):

	if !dictionary.has(key):
		dictionary[key] = []

	dictionary[key].append(value)


func _remove(dictionary: Dictionary, key: Vector3i, value: Object):

	if !dictionary.has(key):
		return

	dictionary[key].erase(value)

	if dictionary[key].is_empty():
		dictionary.erase(key)

#===============================================================================
# COORDINATES
#===============================================================================

func world_to_grid(position: Vector3) -> Vector3i:

	return Utils.world_to_grid(
		grid_map,
		position
	)


func grid_to_world(cell: Vector3i) -> Vector3:

	return Utils.grid_to_world(
		grid_map,
		cell
	)

#===============================================================================
# ENTITIES
#===============================================================================

func register_entity(entity: GridEntity, cell: Vector3i):

	_add(
		entities,
		cell,
		entity
	)


func unregister_entity(entity: GridEntity, cell: Vector3i):

	_remove(
		entities,
		cell,
		entity
	)


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

	emit_signal(
		"entity_left",
		entity,
		old_cell
	)

	emit_signal(
		"entity_entered",
		entity,
		new_cell
	)


func get_entities(cell: Vector3i) -> Array:
	return entities.get(cell, [])


func is_occupied(cell: Vector3i) -> bool:
	return entities.has(cell)

#===============================================================================
# EVENTS
#===============================================================================

func register_event(event: GridEvent, cell: Vector3i):

	_add(
		events,
		cell,
		event
	)


func unregister_event(event: GridEvent, cell: Vector3i):

	_remove(
		events,
		cell,
		event
	)


func get_events(cell: Vector3i) -> Array:
	return events.get(cell, [])


func has_events(cell: Vector3i) -> bool:
	return events.has(cell)

#===============================================================================
# MOVEMENT
#===============================================================================

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


func request_path(
	entity: GridEntity,
	path: Array[Vector3i]
) -> bool:

	for cell in path:

		if !request_move(entity, cell):
			return false

	return true

#===============================================================================
# INTERACTION
#===============================================================================

func interact(entity: GridEntity, target_cell: Vector3i):

	emit_signal(
		"entity_interacted",
		entity,
		target_cell
	)
	
#===============================================================================
# SEARCH
#===============================================================================

func get_player() -> GridEntity:

	return get_entity_by_group("player")


func get_entity_by_group(group_name: StringName) -> GridEntity:

	var node := get_tree().get_first_node_in_group(group_name)

	if node == null:
		return null

	if node is GridEntity:
		return node

	var entity := node.get_node_or_null("GridEntity")

	if entity is GridEntity:
		return entity

	return null
	
func get_entities_by_group(
	group_name: StringName
) -> Array[GridEntity]:

	var result: Array[GridEntity] = []

	for entity_list in entities.values():

		for entity: GridEntity in entity_list:

			if entity.is_in_group(group_name):
				result.append(entity)

	return result
