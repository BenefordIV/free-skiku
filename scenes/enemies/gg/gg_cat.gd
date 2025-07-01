extends CharacterBody2D
class_name GG

enum GgState {SCREEN_LEFT, SCREEN_RIGHT, JUMPING, SLOW}

var jump: Node2D

@onready var gg_sprite: AnimatedSprite2D = $gg_sprite
@onready var gg_shape: CollisionShape2D = $gg_shape
@onready var air_time: Timer = $air_time
@onready var disable_jump_timer: Timer = $disable_jump_timer

@export var prior_state: GgState
var x_origin: float
var _state: GgState = GgState.SCREEN_LEFT

var x_offset: float = randf_range(50.0, 75.0)
const y_velocity: float = 225
const y_velocity_slow: float = 150.0
const _max_x_velocity: float = 150.0 

func _ready() -> void:
	gg_sprite.animation = "gg_snowboard"
	x_origin = self.global_position.x
	self.velocity.y = y_velocity
	
	pass
	
func _enter_tree() -> void:
	SignalHub.on_gg_flip.connect(do_gg_flip)
	
func _physics_process(delta: float) -> void:
	determine_direction()
	if _state == GgState.SCREEN_LEFT:
		self.velocity.x -= 1.5
	
	if _state == GgState.SCREEN_RIGHT:
		self.velocity.x += 1.5
	
	for i in range(get_slide_collision_count()):
		handle_collision(get_slide_collision(i).get_collider())
	
	move_and_slide()

func get_offset() -> float:
	return self.global_position.x - x_origin

func determine_direction() -> void:
	if _state == GgState.JUMPING:
		pass
		
	if _state == GgState.SLOW:
		self.velocity.y = 125
	
	if get_offset() >= x_offset:
		change_state(GgState.SCREEN_LEFT)
	else:
		change_state(GgState.SCREEN_RIGHT) 

func do_gg_flip(j: Node2D) -> void:
	jump = j
	change_state(GgState.JUMPING)
	pass

func handle_collision(col: Node2D) -> void:
	if col is ROCK || col is TREE || col is CHAIR_LIFT:
		SignalHub.emit_on_gg_crash(self)
	if col is MIKU:
		handle_miku_col()

func change_state(new_state: GgState) -> void:
	if _state == new_state:
		return

	if new_state == GgState.SLOW:
		prior_state = _state

	_state = new_state
	change_sprite(_state)

func change_sprite(state: GgState) -> void:
	if state == GgState.SCREEN_LEFT:
		if gg_sprite.flip_h:
			gg_sprite.flip_h = false
		gg_sprite.frame = 1
	elif state == GgState.SCREEN_RIGHT:
		if gg_sprite.flip_h:
			gg_sprite.flip_h = false
		gg_sprite.frame = 0
	elif state == GgState.JUMPING:
		do_jump_anim()
		
func do_jump_anim() -> void:
	gg_sprite.play("gg_flip")
	air_time.start(1)
	disable_jump_timer.start(.25)
	SignalHub.emit_on_gg_jump(jump)
	self.velocity.y = y_velocity
	

func handle_miku_col() -> void:
	SignalHub.emit_on_gg_crash_with_miku()
	SignalHub.emit_game_over()

#region gg_air time
func _on_air_time_timeout() -> void:
	gg_sprite.flip_h = true
	gg_sprite.stop()
	gg_sprite.animation = "gg_snowboard"
	determine_direction()
	

func _on_disable_jump_timer_timeout() -> void:
	SignalHub.emit_on_enable_jump(jump)
#endregion

#region gg_y_vel
func _set_gg_y_velocity(y_vel: float) -> void:
	self.velocity.y = y_vel
