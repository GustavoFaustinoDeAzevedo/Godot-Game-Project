# TODO:
# Detectar chamadas recursivas entre eventos.
extends Node
class_name GridEvent

@onready var entity: GridEntity = $"../GridEntity"

@onready var pages: Array[EventPage] = []
var state := EventState.new()


func _ready():
	assert(entity != null)
	collect_pages()
	for page in pages:
		page.get_runner().finished.connect(_on_runner_finished)

#===============================================================================

func start(
	caller: GridEntity,
	parent_runner: EventRunner = null
):

	var page := get_active_page()

	if page == null:
		return

	var runner := page.get_runner()

	if runner == null:
		return

	if runner.is_running():
		return

	runner.start(
		self,
		entity,
		caller,
		parent_runner
	)
	
#===============================================================================

func _page() -> EventPage:
	return get_active_page()

func get_active_page() -> EventPage:
	for i in range(pages.size() - 1, -1, -1):
		var page := pages[i]
		if page.is_valid(self):
			return page

	return null
	
func collect_pages():

	pages.clear()

	for child in get_children():

		if child is EventPage:
			pages.append(child)

#===============================================================================

func _on_runner_finished(_runner: EventRunner):
	EventScheduler.finish(_runner)

#===============================================================================

func get_runner() -> EventRunner:
	var page := _page()
	if page == null:
		return null

	return page.get_runner()
	
#===============================================================================

func is_running() -> bool:
	var runner := get_runner()
	if runner == null:
		return false

	return runner.is_running()

#===============================================================================

func is_enabled() -> bool:

	var page := _page()
	if page == null:
		return false

	return page.is_enabled()

#===============================================================================

func get_trigger_mode() -> EntityConfig.TriggerMode:
	var page := _page()
	if page == null:
		return EntityConfig.TriggerMode.CALL

	return page.get_trigger_mode()
	
#===============================================================================

func get_state() -> EventState:
	return state

#===============================================================================

func is_parallel() -> bool:

	var page := _page()

	if page == null:
		return false

	return page.get_trigger_mode() == EntityConfig.TriggerMode.PARALLEL

#===============================================================================

func is_autorun() -> bool:

	var page := _page()

	if page == null:
		return false

	return page.get_trigger_mode() == EntityConfig.TriggerMode.AUTORUN

#===============================================================================

## Permite bloquear a execução dependendo da lógica do evento.
## Pode ser sobrescrito em eventos específicos.
func can_execute(_caller: GridEntity) -> bool:
	return true
