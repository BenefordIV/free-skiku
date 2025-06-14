extends Area2D

const MIKU = preload("res://scenes/character/skiier.tscn")
const GG = preload("res://scenes/enemies/gg/gg_cat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is MIKU:
		body.change_state(body.SkiState.SLOW)
	if body is GG:
		body._set_gg_y_velocity(body.y_velocity_slow)

func _on_body_exited(body: Node2D) -> void:
	if body is MIKU:
		body.change_state(body.SkiState.GROUND)
	if body is GG:
		body._set_gg_y_velocity(body.y_velocity)
