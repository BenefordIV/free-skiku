extends Node2D

@onready var chair_up: Area2D = $chair_up
@onready var chair_down: Area2D = $chair_down

const _y_movement: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	chair_up.position.y -= _y_movement * delta
	chair_down.position.y = _y_movement * delta
