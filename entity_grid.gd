extends Node3D

class_name GravityComponent

@export var tile_size: float = 2.0
@export var fall_speed: float = 0.15

var parent: Node3D
var raycast: RayCast3D

func _ready():
	parent = get_parent()
	
	# Cria RayCast3D pra não ter que adicionar manualmente
	raycast = RayCast3D.new()
	raycast.collision_mask = 1
	raycast.target_position = Vector3(0, -tile_size * 1.05, 0)
	raycast.enabled = true
	raycast.debug_shape_custom_color = Color(1, 0, 0) # Vermelho
	raycast.debug_shape_thickness = 2.0
	raycast.add_exception(parent)
	parent.add_child(raycast)

func check_gravity() -> bool:
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		print("Raycast hit: ", collider.name)
		return false
	else:
		print("Raycast is hitting nothing!")
		return true

func fall():
	var target_position = parent.position + Vector3(0, -tile_size, 0)
	var tween = create_tween()
	tween.tween_property(parent, "position", target_position, fall_speed)
	return tween
