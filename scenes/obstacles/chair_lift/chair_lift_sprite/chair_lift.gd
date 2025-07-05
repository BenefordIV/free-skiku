extends StaticBody2D

class_name CHAIR_LIFT

@onready var sky_hb: CollisionShape2D = $sky_hb
@onready var ground_hb: CollisionShape2D = $ground_hb

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sky_hb.disabled = true
	pass # Replace with function body.


func _enter_tree() -> void:
	SignalHub.on_miku_jump.connect(enable_sky_hb)
	SignalHub.on_miku_land.connect(enable_ground_hb)

func enable_sky_hb(node: Node2D) -> void:
	sky_hb.disabled = false
	ground_hb.disabled = true 
	
func enable_ground_hb() -> void:
	sky_hb.disabled = true
	ground_hb.disabled = false 
