extends Node

signal on_duke_eat
signal on_miku_crash
signal game_over

func emit_on_duke_eat() -> void:
	on_duke_eat.emit()

func emit_on_miku_crash() -> void:
	on_miku_crash.emit()

func emit_game_over() -> void:
	game_over.emit()
