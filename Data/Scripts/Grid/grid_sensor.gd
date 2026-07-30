extends Node
class_name GridSensor

@onready var entity: GridEntity = $"../GridEntity"
@onready var world: GridWorld = get_tree().get_first_node_in_group("grid_world")

#===============================================================================
# LIFECYCLE
#===============================================================================

func _ready():

	assert(entity != null)
	assert(world != null)

#===============================================================================
# INTERNAL
#===============================================================================

func _cell_in_offset(offset: Vector3i) -> Vector3i:

	return entity.get_cell() + offset

#===============================================================================
# ENTITY QUERIES
#===============================================================================

func entity_at(cell: Vector3i) -> GridEntity:
	return world.entity_at(cell)

#-------------------------------------------------------------------------------

func entities_at(cell: Vector3i) -> Array[GridEntity]:
	return world.get_entities(cell)

#-------------------------------------------------------------------------------

func has_entity(cell: Vector3i) -> bool:
	return world.has_entity(cell)

#-------------------------------------------------------------------------------

func entity_in_offset(offset: Vector3i) -> GridEntity:

	return entity_at(
		_cell_in_offset(offset)
	)

#-------------------------------------------------------------------------------

func entities_in_offset(offset: Vector3i) -> Array[GridEntity]:

	return entities_at(
		_cell_in_offset(offset)
	)

#===============================================================================
# EVENT QUERIES
#===============================================================================

func event_at(cell: Vector3i) -> GridEvent:
	return world.event_at(cell)

#-------------------------------------------------------------------------------

func events_at(cell: Vector3i) -> Array[GridEvent]:
	return world.get_events(cell)

#-------------------------------------------------------------------------------

func has_event(cell: Vector3i) -> bool:
	return world.has_event(cell)

#-------------------------------------------------------------------------------

func event_in_offset(offset: Vector3i) -> GridEvent:

	return event_at(
		_cell_in_offset(offset)
	)

#===============================================================================
# CELL QUERIES
#===============================================================================

func is_walkable(cell: Vector3i) -> bool:
	return world.is_walkable(entity, cell)

#-------------------------------------------------------------------------------

func is_blocked(cell: Vector3i) -> bool:
	return world.is_blocked(entity, cell)

#-------------------------------------------------------------------------------

func walkable_in_offset(offset: Vector3i) -> bool:

	return is_walkable(
		_cell_in_offset(offset)
	)

#-------------------------------------------------------------------------------

func blocked_in_offset(offset: Vector3i) -> bool:

	return is_blocked(
		_cell_in_offset(offset)
	)
	
func random_cell(radius: int) -> Variant:

	var cells := cells_in_radius(radius)

	if cells.is_empty():
		return null

	return cells.pick_random()
	
func random_walkable_cell(radius: int) -> Variant:

	var cells := cells_in_radius(radius)

	cells.shuffle()

	for cell in cells:

		if cell == entity.get_cell():
			continue

		if !is_walkable(cell):
			continue

		return cell

	return null

#===============================================================================
# DIRECTION HELPERS
#===============================================================================

func entity_in_front(distance := 1) -> GridEntity:

	return entity_in_offset(
		entity.get_rotator().forward * distance
	)

#-------------------------------------------------------------------------------

func entity_behind(distance := 1) -> GridEntity:

	return entity_in_offset(
		entity.get_rotator().back * distance
	)

#-------------------------------------------------------------------------------

func entity_on_right(distance := 1) -> GridEntity:

	return entity_in_offset(
		entity.get_rotator().right * distance
	)

#-------------------------------------------------------------------------------

func entity_on_left(distance := 1) -> GridEntity:

	return entity_in_offset(
		entity.get_rotator().left * distance
	)

#-------------------------------------------------------------------------------

func entity_above(distance := 1) -> GridEntity:

	return entity_in_offset(
		Vector3i.UP * distance
	)

#-------------------------------------------------------------------------------

func entity_below(distance := 1) -> GridEntity:

	return entity_in_offset(
		Vector3i.DOWN * distance
	)

#===============================================================================
# AREA
#===============================================================================

func cells_in_radius(radius: int) -> Array[Vector3i]:

	var cells: Array[Vector3i] = []

	var origin := entity.get_cell()
	var radius_squared := radius * radius

	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			for z in range(-radius, radius + 1):

				var offset := Vector3i(x, y, z)

				# Apenas células dentro da esfera.
				if offset.length_squared() > radius_squared:
					continue

				cells.append(origin + offset)

	return cells
	
#-------------------------------------------------------------------------------

func entities_in_radius(radius: int) -> Array[GridEntity]:

	var result: Array[GridEntity] = []

	for cell in cells_in_radius(radius):

		for other: GridEntity in entities_at(cell):

			if other == entity:
				continue

			result.append(other)

	return result

#-------------------------------------------------------------------------------

func events_in_radius(radius: int) -> Array[GridEvent]:

	var result: Array[GridEvent] = []

	for cell in cells_in_radius(radius):

		result.append_array(events_at(cell))

	return result

#-------------------------------------------------------------------------------

func walkable_cells_in_radius(radius: int) -> Array[Vector3i]:

	var result: Array[Vector3i] = []

	for cell in cells_in_radius(radius):

		if is_walkable(cell):
			result.append(cell)

	return result

#-------------------------------------------------------------------------------

func blocked_cells_in_radius(radius: int) -> Array[Vector3i]:

	var result: Array[Vector3i] = []

	for cell in cells_in_radius(radius):

		if is_blocked(cell):
			result.append(cell)

	return result
	
#===============================================================================
# VISIBILITY
#===============================================================================

func has_line_of_sight_to(cell: Vector3i) -> bool:

	var cells := GridTrace.trace(
		entity.get_cell(),
		cell
	)

	# Ignora a própria célula.
	for i in range(1, cells.size()):

		var current := cells[i]

		# A célula de destino nunca bloqueia a visão.
		if current == cell:
			break

		if blocked_in_offset(
			current - entity.get_cell()
		):
			return false

	return true

#-------------------------------------------------------------------------------

func has_line_of_sight(target: GridEntity) -> bool:

	if target == null:
		return false

	return has_line_of_sight_to(
		target.get_cell()
	)

#-------------------------------------------------------------------------------

func find_entity(
	filter: EntityFilter,
	radius := 9999
) -> GridEntity:

	var list := find_entities(
		filter,
		radius
	)

	if list.is_empty():
		return null

	return list[0]
	
#-------------------------------------------------------------------------------

func find_entities(
	filter: EntityFilter,
	radius := 9999
) -> Array[GridEntity]:

	var result: Array[GridEntity] = []

	for other in entities_in_radius(radius):

		if filter == null:

			result.append(other)
			continue

		if filter.matches(entity, other):

			result.append(other)

	return result

#-------------------------------------------------------------------------------

func nearest_entity(
	filter: EntityFilter,
	radius := 9999
) -> GridEntity:

	var nearest: GridEntity = null
	var nearest_distance := INF

	for other in find_entities(filter, radius):

		var distance := (
			other.get_cell() - entity.get_cell()
		).length_squared()

		if distance < nearest_distance:

			nearest = other
			nearest_distance = distance

	return nearest
