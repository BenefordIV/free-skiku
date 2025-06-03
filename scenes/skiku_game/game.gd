extends Node2D

const DUKE = preload("res://scenes/enemies/duke/duke.tscn")
const MIKU = preload("res://scenes/character/skiier.tscn")
const GG = preload("res://scenes/enemies/gg/gg_cat.tscn")

const MARGIN: float = 70.0

var new_gg: GG

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

#region determine camera pos
func camera_pos() -> Vector2:
	var cam_pos = camera_2d.get_screen_center_position()
	var vp_half = get_viewport_rect().size * 0.5
	var x_min = cam_pos.x + vp_half.x + MARGIN
	var x_max = cam_pos.x - vp_half.x - MARGIN
	var pos_x: float = randf_range(
		x_min,
		x_max
	)
	return Vector2(pos_x, (cam_pos.y - vp_half.y - MARGIN))
#endregion

#region spawn duke
func spawn_duke() -> void:
	var new_duke: DUKE = DUKE.instantiate()
	new_duke.position = camera_pos()
	add_child(new_duke)

func _on_duke_spawn_timer_timeout() -> void:
	spawn_duke()
#endregion

#region spawn gg_cat
func spawn_gg() -> void:
	if new_gg == null:
		new_gg = GG.instantiate()
		new_gg.position = camera_pos()
		new_gg.x_origin = new_gg.position.x
		add_child(new_gg)
		print(new_gg.x_origin)
	
	
func _on_gg_spawn_timer_timeout() -> void:
	spawn_gg()
#endregion

func stop_game() -> void:
	get_tree().paused = true
