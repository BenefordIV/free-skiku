extends Node2D

enum GAME_STATE {PLAYING, PAUSED}

const CHAIR_LIFT_ANIM = preload("res://scenes/obstacles/chair_lift/chair_lift_anim/ski_lift_movement.tscn")
const DUKE = preload("res://scenes/enemies/duke/duke.tscn")
const MIKU = preload("res://scenes/character/skiier.tscn")
const GG = preload("res://scenes/enemies/gg/gg_cat.tscn")
const LINK = preload("res://scenes/enemies/link/link.tscn")

@onready var skiier: MIKU = $skiier

const MARGIN: float = 70.0

#region sprite loaders
var new_gg: GG
var new_link: LINK
var ski_lift: CHAIR_LIFT_ANIM
#endregion

var _state: GAME_STATE = GAME_STATE.PLAYING
var pos_y: float
var y_unit_treshold: float = 1000.0

@onready var camera_2d: Camera2D = $skiier/Camera2D

static var _vp_r: Rect2

static func get_vp() -> Rect2:
	return _vp_r

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos_y = skiier.global_position.y
	get_tree().paused = false
	pass

func _enter_tree() -> void:
	SignalHub.game_over.connect(stop_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_pos_y: float = skiier.global_position.y
	var y_movement: float = abs(current_pos_y - pos_y)
	
	if y_movement >= y_unit_treshold:
		pos_y = skiier.global_position.y
		print(pos_y)
		spawn_ski_lift()
		
	pass

func update_vp() -> void:
	pass
	#var camera_pos = camera_2d.get_screen_center_position()
	#var half_size = get_viewport_rect().size * 0.5
	#_vp_r = Rect2(camera_pos - half_size, camera_pos + half_size)

#region determine camera pos
func camera_pos_X() -> Vector2:
	var cam_pos = skiier.camera.get_screen_center_position()
	var vp_half = get_viewport_rect().size * 0.5
	var x_min = cam_pos.x + vp_half.x + MARGIN
	var x_max = cam_pos.x - vp_half.x - MARGIN
	var pos_x: float = randf_range(
		x_min,
		x_max
	)
	return Vector2(pos_x, (cam_pos.y - vp_half.y - MARGIN))

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

#endregion

#region spawn duke
func spawn_duke() -> void:
	var new_duke: DUKE = DUKE.instantiate()
	new_duke.position = camera_pos_X()
	add_child(new_duke)

func _on_duke_spawn_timer_timeout() -> void:
	spawn_duke()
#endregion

#region spawn gg_cat
func spawn_gg() -> void:
	if new_gg == null:
		new_gg = GG.instantiate()
		new_gg.position = camera_pos_X()
		new_gg.x_origin = new_gg.position.x
		add_child(new_gg)
		print(new_gg.x_origin)
	
	
func _on_gg_spawn_timer_timeout() -> void:
	spawn_gg()
#endregion

func stop_game() -> void:
	get_tree().paused = true


#region spawn link_bird
func _on_link_spawn_timer_timeout() -> void:
	if new_link == null:
		var val = randi_range(1, 2)
		spawn_link(val)

func spawn_link(val: int) -> void:
	var flip = val % 2 != 0
	new_link = LINK.instantiate()
	new_link.position = get_viewport_y(flip)
	new_link.y_origin = new_link.position.y
	add_child(new_link)
	SignalHub.emit_flip_link_values(flip)
#endregion

#region spawn ski-lift
func spawn_ski_lift() -> void:
	if ski_lift == null:
		ski_lift = CHAIR_LIFT_ANIM.instantiate()
		var spawn_point = randf_range(skiier.camera.mark_lift_spawn_min.global_position.x, skiier.camera.mark_lift_spawn_max.global_position.x)
		self.add_child(ski_lift)
		ski_lift.global_position = Vector2(spawn_point, skiier.camera.mark_lift_spawn_min.global_position.y)
#endregion
