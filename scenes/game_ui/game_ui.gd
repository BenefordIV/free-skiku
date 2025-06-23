extends Control

enum GameState {PLAYING, PAUSED}

var _can_press: bool = false

@onready var game_over_label: Label = $game_over_label
@onready var press_space_label: Label = $restart_label
@onready var reset_timer: Timer = $reset_timer
@onready var current_score_label: Label = $current_score_label
@onready var high_score_label: Label = $high_score_label
@onready var high_score_label_2: Label = $high_score_label_2
@onready var paused_label: Label = $paused_label


var _elapsed_time: float = 0.0
var _target_time: float = 2.0
var _score: float = 0.0
var _state: GameState

func _ready() -> void:
	_state = GameState.PLAYING
	high_score_label_2.text = "High Score:%06d" % ScoreManager.high_score
	pass

func _process(delta: float) -> void:
	_elapsed_time += delta
	if _elapsed_time >= _target_time && get_tree().paused == false:
		_elapsed_time = 0.0
		_score += 50
		current_score_label.text = "Score:%06d" % _score

func _unhandled_input(event: InputEvent) -> void:
	if _can_press and event.is_action_pressed("restart"):
		GameManager.load_game_scene()
		pass
		
	if _state == GameState.PLAYING and event.is_action_pressed("pause"):
		paused_label.show()
		_state = GameState.PAUSED
		get_tree().paused = true
		pass
	
	elif _state == GameState.PAUSED and event.is_action_pressed("pause"):
		paused_label.hide()
		_state = GameState.PLAYING
		get_tree().paused = false
		pass

func _enter_tree() -> void:
	SignalHub.on_duke_eat.connect(handle_game_over)
	SignalHub.on_miku_crash.connect(handle_game_over)
	SignalHub.on_gg_crash_with_miku.connect(handle_game_over)
	SignalHub.on_miku_jump.connect(_jump_score)
	
func _jump_score(jump: Node2D) -> void:
	_score += 25
	_set_current_score_label(_score)

func handle_game_over() -> void:
	game_over_label.show()
	reset_timer.start()
	showHighScore()

func _on_reset_timer_timeout() -> void:
	press_space_label.show()
	_can_press = true
	
func _set_current_score_label(score: float) -> void:
	current_score_label.text = "Score:%06d" % score

func showHighScore() -> void:
	if _score > ScoreManager.high_score:
		ScoreManager.high_score = _score
		high_score_label.text = "NEW HIGH SCORE!\n%06d " % _score
	else:
		high_score_label.text = "HIGH SCORE\n%06d" % ScoreManager.high_score
	high_score_label.show()
