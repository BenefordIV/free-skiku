extends Node

const GAME = preload("res://scenes/skiku_game/game.tscn")

var next_scene: PackedScene

func load_game_scene() -> void:
	next_scene = GAME
	get_tree().change_scene_to_packed(next_scene)
