extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GameManager.load_game_scene()
	if event.is_action_pressed("pause"):
		get_tree().quit()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		print("pressed 1")
	if event.is_pressed():
		print("pressed 2")
		GameManager.load_game_scene()
