extends Node3D

const TILE_SIZE = 2.0
const MOVE_TIME = 0.2
const TURN_TIME = 0.15

# 0: Norte (-Z), 1: Oeste (-X), 2: Sul (+Z), 3: Leste (+X)
var facing = 0
var is_moving = false

func _process(_delta):
	if is_moving:
		return

	if Input.is_action_just_pressed("ui_up"):
		# FORÇA O RAIO A SE REPOSICIONAR NO FRAME ATUAL
		$RayCast3D.force_raycast_update() 
		
		if $RayCast3D.is_colliding():
			print("Bloqueado por parede!") # Veja se isso aparece no Output
			return
		move_forward()
		
	elif Input.is_action_just_pressed("ui_left"):
		rotate_camera(1, 90)  # Gira +90º (Esquerda)
		
	elif Input.is_action_just_pressed("ui_right"):
		rotate_camera(-1, -90) # Gira -90º (Direita)
		
	elif Input.is_action_just_pressed("ui_down"):
		rotate_camera(2, 180) # Gira 180º (Costas)

func move_forward():
	is_moving = true
	var direction = get_forward()
	var target_position = position + direction * TILE_SIZE
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, MOVE_TIME)
	await tween.finished
	is_moving = false

func rotate_camera(direction_offset, degrees):
	is_moving = true
	
	# Calcula o próximo facing usando posmod para evitar números negativos
	facing = posmod(facing + direction_offset, 4)
	
	# Removemos o fmod/posmod do callback. Deixamos o ângulo acumular na propriedade
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
	is_moving = false

func get_forward() -> Vector3:
	# Esta tabela DEVE bater exatamente com a rotação visual do seu cenário
	match facing:
		0: return Vector3(0, 0, -1) # Norte
		1: return Vector3(-1, 0, 0) # Oeste
		2: return Vector3(0, 0, 1)  # Sul
		3: return Vector3(1, 0, 0)  # Leste
	return Vector3.ZERO
