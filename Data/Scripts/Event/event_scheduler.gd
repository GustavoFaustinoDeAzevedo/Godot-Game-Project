extends Node

@onready var grid_world: GridWorld = get_tree().get_first_node_in_group("grid_world")

var current_runner: EventRunner = null
var parallel_runners: Array[EventRunner] = []

var autorun_events: Array[GridEvent] = []


#===============================================================================
# LIFECYCLE
#===============================================================================

func _ready():

	assert(grid_world != null)

	grid_world.entity_entered.connect(_on_entity_entered)
	grid_world.entity_left.connect(_on_entity_left)
	grid_world.entity_interacted.connect(_on_entity_interacted)

	call_deferred("_start_autoruns")


#===============================================================================
# AUTORUN
#===============================================================================

## Registra um evento que deve iniciar automaticamente.
func register_autorun(event: GridEvent):

	if autorun_events.has(event):
		return

	autorun_events.append(event)


## Inicia todos os eventos AUTORUN registrados.
func _start_autoruns():

	for event: GridEvent in autorun_events:

		if !event.is_enabled():
			continue

		request(
			event,
			event.entity
		)


#===============================================================================
# SIGNALS
#===============================================================================

func _on_entity_entered(
	entity: GridEntity,
	cell: Vector3i
):

	dispatch(
		entity,
		cell,
		EntityConfig.TriggerMode.ENTER
	)


func _on_entity_left(
	entity: GridEntity,
	cell: Vector3i
):

	dispatch(
		entity,
		cell,
		EntityConfig.TriggerMode.EXIT
	)


func _on_entity_interacted(
	entity: GridEntity,
	cell: Vector3i
):

	dispatch(
		entity,
		cell,
		EntityConfig.TriggerMode.ACTION
	)


#===============================================================================
# DISPATCH
#===============================================================================

func dispatch(
	caller: GridEntity,
	cell: Vector3i,
	mode: EntityConfig.TriggerMode
):

	for event: GridEvent in grid_world.get_events(cell):

		if !event.is_enabled():
			continue

		if event.get_trigger_mode() != mode:
			continue

		if !event.can_execute(caller):
			continue

		request(
			event,
			caller
		)


#===============================================================================
# REQUEST
#===============================================================================

func request(
	event: GridEvent,
	caller: GridEntity
):

	var runner := event.get_runner()

	match event.get_trigger_mode():

		EntityConfig.TriggerMode.PARALLEL:

			if parallel_runners.has(runner):
				return

			parallel_runners.append(runner)

			event.start(caller)


		_:

			if current_runner != null:
				return

			current_runner = runner

			event.start(caller)


#===============================================================================
# FINISH
#===============================================================================

func finish(
	runner: EventRunner
):

	if runner == current_runner:
		current_runner = null

	parallel_runners.erase(runner)


#===============================================================================
# STATE
#===============================================================================

func is_busy() -> bool:

	return current_runner != null
