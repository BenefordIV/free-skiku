extends Node2D

var new_link: LINK

const LINK = preload("res://scenes/enemies/link/link.tscn")

@onready var skiier: MIKU = $skiier

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func get_viewport_y(flip: bool) -> Vector2:
	var pos_y: float = randf_range(
		skiier.camera.mark_u.global_position.y,
		skiier.camera.mark_l.global_position.y
	)
	
	var pos_x: float = skiier.camera.mark_u.global_position.x
	if flip:
		pos_x = skiier.camera.mark_x_u.global_position.x
		
	print(pos_x)
	return Vector2(pos_x, pos_y)

func _on_timer_timeout() -> void:
	var val = randi_range(1, 2)
	spawn_link(val)

func spawn_link(val: int) -> void:
	var flip = val % 2 != 0
	if new_link == null:
		new_link = LINK.instantiate()
		new_link.position = get_viewport_y(flip)
		new_link.y_origin = new_link.position.y
		add_child(new_link)
		SignalHub.emit_flip_link_values(flip)
