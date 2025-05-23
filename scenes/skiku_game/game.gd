extends Node2D

const DUKE = preload("res://scenes/enemies/duke/duke.tscn")
const MIKU = preload("res://scenes/character/skiier.tscn")
const MARGIN: float = 70.0
@onready var duke_speed_timer: Timer = $duke_speed_timer
@onready var camera_2d: Camera2D = $skiier/Camera2D

static var _vp_r: Rect2

static func get_vp() -> Rect2:
	return _vp_r

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	pass

func _enter_tree() -> void:
	SignalHub.game_over.connect(stop_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_vp()
	pass

func update_vp() -> void:
	pass
	#var camera_pos = camera_2d.get_screen_center_position()
	#var half_size = get_viewport_rect().size * 0.5
	#_vp_r = Rect2(camera_pos - half_size, camera_pos + half_size)

#region spawn duke
func spawn_duke() -> void:
	var new_duke: DUKE = DUKE.instantiate()
	var cam_pos = camera_2d.get_screen_center_position()
	var vp_half = get_viewport_rect().size * 0.5
	var x_min = cam_pos.x + vp_half.x + MARGIN
	var x_max = cam_pos.x - vp_half.x - MARGIN
	var pos_x: float = randf_range(
		x_min,
		x_max
	)
	new_duke.position = Vector2(pos_x, (cam_pos.y - vp_half.y - MARGIN))
	add_child(new_duke)
#endregion

func _on_duke_spawn_timer_timeout() -> void:
	spawn_duke()
	print("duke spawn")

func stop_game() -> void:
	get_tree().paused = true
