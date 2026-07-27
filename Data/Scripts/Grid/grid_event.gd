extends Node
class_name GridEvent

@onready var entity: GridEntity = $"../GridEntity"
@onready var config: EntityConfig = $"../EntityConfig"
@onready var runner: EventRunner = $"../EventRunner"

#===============================================================================

func _ready():

	assert(entity != null)
	assert(config != null)
	assert(runner != null)

	runner.finished.connect(_on_runner_finished)

#===============================================================================

## Solicita a execução deste evento.
func start(
	caller: GridEntity,
	parent_runner: EventRunner = null
):

	if !is_enabled():
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

## Interrompe o evento.
func stop():

	if runner.is_running():
		runner.finish()

#===============================================================================

func _on_runner_finished(_runner: EventRunner):

	EventScheduler.finish(_runner)

#===============================================================================

func get_runner() -> EventRunner:
	return runner
	
#===============================================================================

func is_running() -> bool:
	return runner.is_running()

#===============================================================================

func is_enabled() -> bool:
	return config.enabled

#===============================================================================

func get_trigger_mode() -> EntityConfig.TriggerMode:
	return config.trigger_mode

#===============================================================================

func is_parallel() -> bool:
	return config.trigger_mode == EntityConfig.TriggerMode.PARALLEL

#===============================================================================

func is_autorun() -> bool:
	return config.trigger_mode == EntityConfig.TriggerMode.AUTORUN

#===============================================================================

## Permite bloquear a execução dependendo da lógica do evento.
## Pode ser sobrescrito em eventos específicos.
func can_execute(_caller: GridEntity) -> bool:
	return true
