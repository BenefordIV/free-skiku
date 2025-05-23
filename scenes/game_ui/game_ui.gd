extends Control

var _can_press: bool = false

@onready var game_over_label: Label = $game_over_label
@onready var press_space_label: Label = $restart_label
@onready var reset_timer: Timer = $reset_timer

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if _can_press and event.is_action_pressed("restart"):
		GameManager.load_game_scene()

func _enter_tree() -> void:
	SignalHub.on_duke_eat.connect(on_duke_eat)
	SignalHub.on_miku_crash.connect(on_miku_crash)
	
func on_duke_eat() -> void:
	game_over_label.show()
	reset_timer.start()
	print(reset_timer.paused)
	print(reset_timer.time_left)

func on_miku_crash() -> void:
	game_over_label.show()
	reset_timer.start()
	print(reset_timer.paused)
	print(reset_timer.time_left)

func _on_reset_timer_timeout() -> void:
	print("can restart")
	press_space_label.show()
	_can_press = true
	print(_can_press)
	
