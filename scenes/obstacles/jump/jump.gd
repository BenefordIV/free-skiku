extends StaticBody2D

class_name JUMP

@onready var jump_takeoff_point: CollisionShape2D = $jumpTakeoffPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _enter_tree() -> void:
	SignalHub.on_enable_jump.connect(enable_jumps)
	SignalHub.on_miku_jump.connect(disable_jumps)
	SignalHub.on_gg_jump.connect(disable_jumps)
	
func disable_jumps(jump: JUMP) -> void:
	jump.jump_takeoff_point.disabled = true
	
func enable_jumps(jump: JUMP) -> void:
	jump.jump_takeoff_point.disabled = false
	
