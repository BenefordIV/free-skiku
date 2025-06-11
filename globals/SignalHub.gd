extends Node

signal on_duke_eat
signal on_miku_crash
signal on_miku_jump
signal on_miku_land
signal game_over
signal on_gg_jump
signal on_gg_spawn
signal on_enable_jump
signal on_gg_crash
signal on_gg_crash_with_miku
signal on_flip_link_values

func emit_on_duke_eat() -> void:
	on_duke_eat.emit()

func emit_on_miku_crash() -> void:
	on_miku_crash.emit()

func emit_game_over() -> void:
	game_over.emit()

func emit_on_miku_jump(node: Node2D) -> void:
	on_miku_jump.emit(node)
	
func emit_on_gg_jump(node: Node2D) -> void:
	on_gg_jump.emit(node)
	
func emit_on_gg_spawn(nearest_ramp: Node2D) -> void:
	on_gg_spawn.emit()
	
func emit_on_enable_jump(node: Node2D) -> void:
	on_enable_jump.emit(node)

func emit_on_gg_crash(gg: GG) -> void:
	on_gg_crash.emit(gg)

func emit_on_miku_land() -> void:
	on_miku_land.emit()

func emit_on_gg_crash_with_miku() -> void:
	on_gg_crash_with_miku.emit()

func emit_flip_link_values(flip: bool) -> void:
	on_flip_link_values.emit(flip)
