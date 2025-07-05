extends Node

const GAME: PackedScene = preload("res://scenes/ski_2d_game/game_base/game.tscn")
const MAIN_SCREEN: PackedScene = preload("res://scenes/ski_2d_game/main_screen/main_screen.tscn")
const SIMPLE_TRANSITION: PackedScene = preload("res://scenes/ski_2d_game/screen_transition/simple_transition.tscn")

var next_scene: PackedScene

func load_next_scene(ns: PackedScene) -> void:
	next_scene = ns
	print(next_scene.get_state())
	var st = SIMPLE_TRANSITION.instantiate()
	add_child(st)

func load_game_scene() -> void:
	load_next_scene(GAME)

func load_main_screen() -> void:
	load_next_scene(MAIN_SCREEN)
	
