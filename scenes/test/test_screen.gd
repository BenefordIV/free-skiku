extends Node2D

const MARGIN = 70.0

const DUKE = preload("res://scenes/enemies/duke/duke.tscn")
@onready var camera_2d: Camera2D = $skiier/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enter_tree() -> void:
	SignalHub.on_duke_eat.connect(stop_game)

func spawn_duke() -> void:
	var new_duke: DUKE = DUKE.instantiate()
	var cam_pos = camera_2d.get_screen_center_position()
	var vp_half = get_viewport_rect().size * 0.5
	var x_min = cam_pos.x - vp_half.x - MARGIN
	var x_max = cam_pos.x + vp_half.x + MARGIN
	print (str(cam_pos.x) + " " + str(cam_pos.y))
	print(x_min)
	print(x_max)
	var pos_x: float = randf_range(
		x_min,
		x_max
	)
	new_duke.position = Vector2(pos_x, cam_pos.y - MARGIN)
	print("Duke Pos:" + str(new_duke.position.x) + " " + str(new_duke.position.y))
	add_child(new_duke)

func _on_spawn_duke_timer_timeout() -> void:
	spawn_duke()

func stop_game() -> void:
	get_tree().paused = true
