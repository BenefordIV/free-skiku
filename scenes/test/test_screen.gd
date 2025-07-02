extends Node2D

var new_link: LINK
var ski_lift: CHAIR_LIFT_ANIM

const LINK = preload("res://scenes/enemies/link/link.tscn")
const CHAIR_LIFT_ANIM = preload("res://scenes/obstacles/chair_lift/chair_lift_anim/ski_lift_movement.tscn")

@onready var skiier: MIKU = $skiier

var pos_y: float
var y_unit_treshold: float = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos_y = skiier.global_position.y
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_pos_y: float = skiier.global_position.y
	var y_movement: float = abs(current_pos_y - pos_y)
	
	if y_movement >= y_unit_treshold:
		pos_y = skiier.global_position.y
		print(pos_y)
		spawn_ski_lift()
		
	pass
	

func spawn_ski_lift() -> void:
	if ski_lift == null:
		ski_lift = CHAIR_LIFT_ANIM.instantiate()
		var spawn_point = randf_range(skiier.camera.mark_lift_spawn_min.global_position.y, skiier.camera.mark_lift_spawn_max.global_position.y)
		self.add_child(ski_lift)
		ski_lift.global_position = Vector2(skiier.camera.mark_lift_spawn_min.position.x, spawn_point)
