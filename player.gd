extends CharacterBody3D

const TILE_SIZE = 2.0
const MOVE_TIME = 0.40
const TURN_TIME = 0.2

# 0: Norte (-Z), 1: Oeste (-X), 2: Sul (+Z), 3: Leste (+X)
var facing = 0

var is_moving: bool = false

func _physics_process(delta: float) -> void:
	if is_moving:
		return
	if not is_on_floor():
		is_moving = true
		velocity += get_gravity()*delta
		move_and_slide()
		is_moving = false
		return

	if Input.is_action_just_pressed("move_up"):
		$RayCast3D.force_raycast_update() 
		if $RayCast3D.is_colliding():
			return
		move_forward()
		
	elif Input.is_action_just_pressed("move_left"):
		rotate_camera(1, 90)
		
	elif Input.is_action_just_pressed("move_right"):
		rotate_camera(-1, -90)
		
	elif Input.is_action_just_pressed("move_down"):
		rotate_camera(2, 180)
	
	move_and_slide()

func move_forward():
	
	if is_on_floor():
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + transform.basis * Vector3(0, 0, -2), 0.2)
		await tween.finished
		is_moving = false


func rotate_camera(direction_offset, degrees):
	is_moving = true
	
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
	is_moving = false

func get_forward() -> Vector3:
	match facing:
		0: return Vector3(0, 0, -1) # Norte
		1: return Vector3(-1, 0, 0) # Oeste
		2: return Vector3(0, 0, 1)  # Sul
		3: return Vector3(1, 0, 0)  # Leste
	return Vector3.ZERO
