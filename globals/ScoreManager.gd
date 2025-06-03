extends Node

const SCORE_PATH: String = "user://free_ski.tres"

var _high_score: int = 0
var high_score: int:
	get:
		return _high_score 
	set(value):
		if value > _high_score:
			_high_score = value
			save_high_score()


func _ready() -> void:
	load_high_score()


func load_high_score() -> void:
	if ResourceLoader.exists(SCORE_PATH) == true:
		var hsr: HighScoreResource = load(SCORE_PATH)
		if hsr:
			_high_score = hsr.high_score
			pass


func save_high_score() -> void:
	var hsr: HighScoreResource = HighScoreResource.new()
	hsr.high_score = _high_score
	ResourceSaver.save(hsr, SCORE_PATH)
