extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GameManager.load_game_scene()
	if event.is_action_pressed("pause"):
		get_tree().quit()
