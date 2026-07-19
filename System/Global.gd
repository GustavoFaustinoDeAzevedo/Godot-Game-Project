extends Node

var debug_mode: bool = false

var player: CharacterBody3D = null

# Atalho para ativar/desativar o debug durante o jogo
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().reload_current_scene()
	if event is InputEventKey and event.pressed and event.keycode == KEY_F3:
		debug_mode = !debug_mode
		
		if debug_mode:
			print("--- MODO DEBUG: ATIVADO ---")
		else:
			print("--- MODO DEBUG: DESATIVADO ---")
