extends CharacterBody3D

@export_category("Player Config")
@export_group("Parameters")
##Define tamanho do personagem
@export var PLAYER_HEIGHT: float = 10.6
@export_group("Movement")
##Define o tamanho de cada tile
@export var TILE_SIZE: float = 10.0
##Define tamanho máximo do tile que o jogador pode subir 
@export var MAX_CLIMBABLE_HEIGHT: float = 5.0
##Velocidade de movimento do personagem
@export var MOVE_TIME: float = 0.4
##Velocidade da "virada"
@export var TURN_TIME: float = 0.2
##Minima altura em que o personagem pode ficar
@export var MIN_HEIGHT: float = -200.0
##Tamanho do histórico de posições do personagem
@export var MAX_HISTORY: int = 10
@export_category("Mouse Config")
@export var sensitivity: float = 0.003
@export var yaw_min_angle: int = -75
@export var yaw_max_angle: int = 75
@export var pitch_min_angle: int = -75
@export var pitch_max_angle: int = 75
@export_category("Maps")
@export var grid_map: GridMap

@onready var yaw_node = $CameraYaw
@onready var pitch_node = $CameraYaw/CameraPitch

@onready var collision_shape = $CollisionShape

@onready var footstep_player = $FootstepPlayer



# 0: Norte (-Z), 1: Oeste (-X), 2: Sul (+Z), 3: Leste (+X)
var facing: int = 0
var history: Array[Vector3] = []

var is_walking: bool = false
var is_falling: bool = false
var is_crouched: bool = false

var can_move: bool = true

var footstep_sounds = {}

## Coordenada do personagem convertida pra INT
var grid_coord: Vector3i


func _ready():
	Global.player = self
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var terrain = ["wood", "concrete", "grass"]
	
	for t in terrain:
		var directory = "res://Audio/SE/Footsteps/" + t + "/"
		footstep_sounds[t] = load_sounds_from_folder(directory)


func load_sounds_from_folder(folder_directory: String) -> Array:
	var sounds = []
	var dir = DirAccess.open(folder_directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with(".wav") or file_name.ends_with(".ogg")):
				sounds.append(load(folder_directory + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	return sounds

func play_footstep(_terrain: String = ''):
	if not is_on_floor():
		return
		
	if _terrain == '':
		var collision_point = grid_coord
		var item_id = grid_map.get_cell_item(collision_point)
		if item_id == -1:
			collision_point += Vector3i.DOWN
			item_id = grid_map.get_cell_item(collision_point)
			if item_id == -1:
				return
		var terrain_name = grid_map.mesh_library.get_item_name(item_id).split('_')
		if terrain_name.size() >= 2:
			_terrain = terrain_name[-2]
	
	if footstep_sounds.has(_terrain):
		var sounds_list = footstep_sounds[_terrain]
		if sounds_list.size() > 0:
			footstep_player.stream = sounds_list.pick_random()
			footstep_player.pitch_scale = randf_range(0.9, 1.1)
			footstep_player.play()



func _input(event):
	if Input.mouse_mode == 2:
		if event is InputEventMouseMotion:
			# Rotação Horizontal (no nó Yaw)
			yaw_node.rotate_y(-event.relative.x * sensitivity)
			
			# Rotação Vertical (no nó Pitch)
			pitch_node.rotate_x(-event.relative.y * sensitivity)
			
			# Limite (Clamp) pra não quebrar o pescoço
			yaw_node.rotation.y = clamp(yaw_node.rotation.y, deg_to_rad(yaw_min_angle), deg_to_rad(yaw_max_angle))
			pitch_node.rotation.x = clamp(pitch_node.rotation.x, deg_to_rad(pitch_min_angle), deg_to_rad(pitch_max_angle))
	else:
		yaw_node.rotation.y = 0
		pitch_node.rotation.x = 0



func _physics_process(delta: float) -> void:
	if is_walking:
		return
		
	if not is_on_floor():
		can_move = false
		velocity += get_gravity()*delta
		if global_position.y <= MIN_HEIGHT:
			redo_movement()
		can_move = true
		
	grid_coord = Utils.global_to_grid(grid_map, global_position)
	
	@warning_ignore("narrowing_conversion")
	var coords_changed = history.is_empty() or global_position != history[-1]
	if coords_changed and is_on_floor() and can_move:
		history.append(global_position)
		play_footstep()
		if history.size() > MAX_HISTORY:
			history.remove_at(0)
	move_and_slide()



func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("ctrl"):
		if Input.mouse_mode == 2:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if can_move and is_on_floor():
		var direction: Vector2i = Input.get_vector("move_left","move_right","move_up","move_down")
				
		if Input.is_action_just_pressed("turn_left"):
			rotate_camera(1, 90)
		elif Input.is_action_just_pressed("turn_right"):
			rotate_camera(-1,-90)
		#elif Input.is_action_just_pressed("move_down"):
		#	rotate_camera(2, 180)
		elif direction != Vector2i.ZERO:
			var orientation = Utils.get_orientation(facing)
			var right = Vector3i(-orientation.z, 0, orientation.x)
			
			var movement: Vector3i = Vector3i.ZERO
			movement += orientation * Vector3i.ONE * -direction.y
			movement += right * Vector3i.ONE * direction.x
			
			var target_coord = grid_coord + movement
			
			var stairs_height: float = get_climb_height_if_valid(target_coord)
			
			# Se for -999.0, é uma parede/obstáculo. Cancela o movimento.
			if stairs_height == -999.0:
				return
			else:
				# Movimento permitido!
				print('Subindo/Descendo: ', stairs_height)
				
				# O Tween deve adicionar a altura final calculada
				await move_forward(Vector3(movement) + Vector3(0, stairs_height, 0))





func move_forward(direction: Vector3):
	is_walking = true
	
	var target_position = global_position + direction * TILE_SIZE

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, MOVE_TIME)
	
	can_move = false
	await get_tree().create_timer(MOVE_TIME).timeout
	can_move = true

	is_walking = false



func rotate_camera(direction_offset, degrees):
	can_move = false
	
	facing = posmod(facing + direction_offset, 4)
	
	var target_rotation = rotation.y + deg_to_rad(degrees)
	
	var tween = create_tween()
	tween.tween_property(
		self,
		"global_rotation:y",
		target_rotation,
		TURN_TIME * (2 if abs(degrees) == 180 else 1)
	)
	
	await tween.finished
	can_move = true

func redo_movement():
	if not history.is_empty():
		var last_position = history.pop_back()
		global_position = last_position


func get_climb_height_if_valid(target: Vector3i) -> float:

	var floor_height_step: float = get_block_height(grid_coord)
	
	var target_height_step: float = get_block_height(target)
	var target_height_base: float = 1.0 if target_height_step != 0 else get_block_height(target + Vector3i.DOWN) 
	
	var target_height = target_height_base + target_height_step + target.y - (MIN_HEIGHT+TILE_SIZE)/TILE_SIZE
	var floor_height = floor_height_step + grid_coord.y - MIN_HEIGHT/TILE_SIZE
	var height_difference = target_height - floor_height
	
	print('global coord: ',global_position,' grid coord: ',grid_coord,' target coord: ',target,)
	print(' floor_height_step: ', floor_height_step)
	print('target_height_base: ',target_height_base, ' target_height_step: ',target_height_step)
	print('target height: ', target_height,' floor_height: ',floor_height, ' height_difference: ', height_difference)
	if height_difference > (MAX_CLIMBABLE_HEIGHT / TILE_SIZE):
		return -999.0 
		
	# Se tem um degrau na frente (target_step_height > 0), o personagem vai 
	# pisar nele, logo o corpo só vai ocupar o espaço acima de target.
	var initial_block = target
	
	if target_height_step > 0:
		initial_block = target + Vector3i.UP
		
	var block_height_tiles = ceil(PLAYER_HEIGHT / TILE_SIZE)
	
	# Loop testa apenas do bloco inicial do corpo para cima
	for i in range(block_height_tiles):
		var check_coord = initial_block + Vector3i(0, i, 0)
		
		# Se a altura neste bloco for maior que 0, tem algo batendo na cabeça/corpo
		if get_block_height(check_coord) > 0:
			print("Bloqueado: Bate a cabeça no teto!")
			return -999.0
			
	# Caminho livre! Retorna o esforço (diferença de altura)
	return height_difference


## função para acha a altura do bloco;
## vector_orientation: (-1 = bloco invertido, 1 = bloco normal)
func get_block_height(coord: Vector3i, _vector_orientation: int = 1) -> float:
	var block_id = grid_map.get_cell_item(coord)
	if block_id == -1:
		return 0
	
	var block_orientation = grid_map.get_cell_item_orientation(coord)
	if block_orientation != -1:
		var block_basis = grid_map.get_basis_with_orthogonal_index(block_orientation)
		var up: int = block_basis.y.dot(Vector3i.UP)
		if up != _vector_orientation:
			return 1.0
			
	return float(grid_map.mesh_library.get_item_name(block_id).split('_')[-1]) ## A altura será informada no final do nome após o ultimo '_'
