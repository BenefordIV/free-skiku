extends Node2D

class_name CHAIR_LIFT_ANIM

@onready var chair_up: StaticBody2D = $chair_up
@onready var chair_down: StaticBody2D = $chair_down

const _y_movement: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.on_ski_lift_despawn.connect(despawn_ski_lift)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	chair_up.position.y -= _y_movement * delta
	chair_down.position.y += _y_movement * delta

func despawn_ski_lift() -> void:
	queue_free()
