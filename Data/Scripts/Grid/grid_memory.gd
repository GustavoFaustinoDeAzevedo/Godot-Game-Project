extends Node
class_name GridMemory

var records: Dictionary = {}

#===============================================================================
# INTERNAL
#===============================================================================

func _time() -> float:

	return Time.get_ticks_msec() / 1000.0

#===============================================================================
# PUBLIC
#===============================================================================

func remember(
	key: StringName,
	entity: GridEntity,
	cell: Vector3i
):

	var memory := MemoryRecord.new()

	memory.entity = entity
	memory.cell = cell
	memory.timestamp = _time()

	records[key] = memory

#-------------------------------------------------------------------------------

func forget(key: StringName):

	records.erase(key)

#-------------------------------------------------------------------------------

func clear():

	records.clear()

#-------------------------------------------------------------------------------

func has(key: StringName) -> bool:

	return records.has(key)

#-------------------------------------------------------------------------------

func get_record(key: StringName) -> MemoryRecord:

	return records.get(key)

#-------------------------------------------------------------------------------

func get_entity(key: StringName) -> GridEntity:

	var memory := get_record(key)

	if memory == null:
		return null

	return memory.entity

#-------------------------------------------------------------------------------

func get_cell(key: StringName) -> Vector3i:

	var memory := get_record(key)

	if memory == null:
		return Vector3i.ZERO

	return memory.cell

#-------------------------------------------------------------------------------

func get_timestamp(key: StringName) -> float:

	var memory := get_record(key)

	if memory == null:
		return -1.0

	return memory.timestamp

#-------------------------------------------------------------------------------

func age(key: StringName) -> float:

	var memory := get_record(key)

	if memory == null:
		return INF

	return _time() - memory.timestamp
