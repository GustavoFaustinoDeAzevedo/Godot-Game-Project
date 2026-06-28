extends CharacterBody3D

@export_category("Player Config")
@export_group("Parameters")
@export_group("Movement")
##Define o tamanho de cada tile
@export var TILE_SIZE = 1.0
##Velocidade de movimento do personagem
@export var MOVE_TIME = 0.40
##Velocidade da "virada"
@export var TURN_TIME = 0.2
##Minima altura em que o personagem pode ficar
@export var MIN_HEIGHT = -20
##Tamanho do histórico de posições do personagem
@export var MAX_HISTORY = 10
@export_category("Mouse Config")
@export var sensitivity = 0.003
@export var yaw_min_angle = -75
@export var yaw_max_angle = 75
@export var pitch_min_angle = -75
@export var pitch_max_angle = 75

@onready var yaw_node = $CameraYaw
@onready var pitch_node = $CameraYaw/CameraPitch

# 0: Norte (-Z), 1: Oeste (-X), 2: Sul (+Z), 3: Leste (+X)
var facing = 0
var history: Array[Vector3] = []

var is_walking: bool = false
var is_falling: bool = false
var is_facing_wall = false
var is_facing_stairs = false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		# Rotação Horizontal (no nó Yaw)
		yaw_node.rotate_y(-event.relative.x * sensitivity)
		
		# Rotação Vertical (no nó Pitch)
		pitch_node.rotate_x(-event.relative.y * sensitivity)
		
		# Limite (Clamp) pra não quebrar o pescoço
		yaw_node.rotation.y = clamp(yaw_node.rotation.y, deg_to_rad(yaw_min_angle), deg_to_rad(yaw_max_angle))
		pitch_node.rotation.x = clamp(pitch_node.rotation.x, deg_to_rad(pitch_min_angle), deg_to_rad(pitch_max_angle))

func _physics_process(delta: float) -> void:
	if is_walking:
		return
		
	if is_falling:
		velocity += get_gravity()*delta
		if global_position.y <= MIN_HEIGHT:
			redo_movement()
		
	elif not is_falling and is_on_floor():
		if Input.is_action_just_pressed("move_up"):
			$RayCastHead.force_raycast_update() 
			$RayCastBelly.force_raycast_update() 
			$RayCastFoot.force_raycast_update()
			
			is_facing_wall = $RayCastHead.is_colliding() or $RayCastBelly.is_colliding()
			is_facing_stairs = $RayCastFoot.is_colliding() and not is_facing_wall
			
			if is_facing_wall:
				return
			elif is_facing_stairs:
				move_forward(0.5)
			else:
				move_forward()
			
			
		elif Input.is_action_just_pressed("move_left"):
			rotate_camera(1, 90)
			
		elif Input.is_action_just_pressed("move_right"):
			rotate_camera(-1, -90)
			
		elif Input.is_action_just_pressed("move_down"):
			rotate_camera(2, 180)
	move_and_slide()
	
func _process(_delta: float) -> void:
	
	is_falling = not is_on_floor()
	
	@warning_ignore("narrowing_conversion")
	var grid_pos = Vector3(global_position.x, global_position.y, global_position.z)
	if (history.is_empty() or grid_pos != history[-1]) and not is_falling and not is_walking:
		history.append(grid_pos)
		if history.size() > MAX_HISTORY:
			history.remove_at(0)


func move_forward(_height = 0.0):
	if is_on_floor():			
		is_walking = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + transform.basis * Vector3(0, _height, -TILE_SIZE), 0.2)
		await tween.finished
		is_walking = false


func rotate_camera(direction_offset, degrees):
	is_walking = true
	
	# Calcula o próximo facing usando posmod para evitar números negativos
	facing = posmod(facing + direction_offset, 4)
	
	# rotation.y + X. Isso impede que o ângulo dê "saltos" fantasmas.
	var target_rotation = rotation.y + deg_to_rad(degrees)
	
	var tween = create_tween()
	tween.tween_property(
		self, 
		"rotation:y", 
		target_rotation, 
		TURN_TIME * (2 if abs(degrees) == 180 else 1)
	)
	
	await tween.finished
	is_walking = false

func get_forward() -> Vector3:
	match facing:
		0: return Vector3(0, 0, -1) # Norte
		1: return Vector3(-1, 0, 0) # Oeste
		2: return Vector3(0, 0, 1)  # Sul
		3: return Vector3(1, 0, 0)  # Leste
	return Vector3.ZERO
	
func redo_movement():
	if not history.is_empty():
		var last_position = history.pop_back()
		global_position = last_position
