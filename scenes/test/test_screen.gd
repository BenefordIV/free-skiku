extends Node2D

const MARGIN = 70.0

var new_link: LINK

const LINK = preload("res://scenes/enemies/link/link.tscn")

@onready var test_mark_u: Marker2D = $skiier/Camera2D/test_mark_u
@onready var test_mark_l: Marker2D = $skiier/Camera2D/test_mark_l
@onready var camera_2d: Camera2D = $skiier/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func get_viewport_y() -> Vector2:
	var pos_y: float = randf_range(
		test_mark_u.global_position.y,
		test_mark_l.global_position.y
	)
	return Vector2(test_mark_u.global_position.x, pos_y)

func _on_timer_timeout() -> void:
	var val = randi()
	spawn_link(val)

func spawn_link(val: int) -> void:
	if new_link == null:
		new_link = LINK.instantiate()
		new_link.position = get_viewport_y()
		new_link.y_origin = new_link.position.y
		#if the random int is divisible by 2, don't flip value
		add_child(new_link)
	


func _on_side_wall_l_body_entered(body: Node2D) -> void:
	if body is LINK:
		body.queue_free()


func _on_top_wall_body_entered(body: Node2D) -> void:
	if body is LINK:
		body.queue_free()
