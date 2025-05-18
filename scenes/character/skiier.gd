extends CharacterBody2D

enum SkiState {JUMPED, GROUND, CRASH, YETI}

const DOWN : Vector2 = Vector2(0.0, 1.0)

@onready var sprite_sheet: AnimatedSprite2D = $SpriteSheet
@onready var ski_col: CollisionShape2D = $CollisionShape2D
@onready var air_timer: Timer = $AirTimer

var braking : bool

var _d_index   : int: set = d_index_set
var _direction : Vector2: set = direction_set
var _drag      : float: get = drag_get
var _force : float
var _state: SkiState = SkiState.GROUND
var _miku_scale: float = 0.0
var _player_mask: float = 1.0

@export var free_move      : bool = true
@export var dh_force : float = 500.0
@export var running_drag   : float = 1.48
@export var braking_drag   : float = 4.5
@export var side_redirect  : float = 22.0
@export var mass : float = 1.0

#The index of the sprite. X = sprite index, Y = Flip Sprite
const SPRITE_INDEX := [[3, true], [2, true], [1, true], [0, false], 
							[1, false], [2, false], [3, false]]

const DIRECTION_LOOKUP := [Vector2(-1, 0), Vector2(-.867, .5), Vector2(-.5, .867),
							Vector2(0.0, 1.0), Vector2(.5, .867), Vector2(.867, .5), Vector2(1, 0)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._direction = Vector2(1.0, 0.0)
	self.velocity = Vector2(0.0, 0.0)
	sprite_sheet.animation = "ski_anim"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var accel := self._force / self.mass
	self.velocity = self.velocity + ((self._direction*accel) - (self._drag*self.velocity)) * delta
	self.move_and_slide()
	
	for i in range(get_slide_collision_count()):
		handle_collision(get_slide_collision(i).get_collider())
	
	# Side friction
	var vn := self.velocity.normalized().dot(_direction)
	var amount_to_redirect := (self.side_redirect*delta)
	var penalized_vel := self.velocity * (1.0 - vn)
	var pmagnitude := (penalized_vel*amount_to_redirect).length()
	var redirected := (penalized_vel * (1.0-amount_to_redirect)) + (_direction*pmagnitude)
	
	self.velocity = (self.velocity * vn) + redirected

func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.handle_direction(get_global_mouse_position() - self.global_position)

func handle_direction(dir:Vector2) -> void:
	dir = dir.normalized()
	self._d_index = self.calc_index(dir)
	if free_move:
		self._direction = dir
	else:
		self._direction = DIRECTION_LOOKUP[self.d_index]

func calc_index(dir:Vector2) -> int:
	var i := 3
	if dir.y < .259: i = 6
	elif dir.y < .708: i = 5
	elif dir.y < .966: i = 4
	if (dir.x < 0) and not (i == 3): 
		i = 3 - (i - 3)
	return i


#region direction_set
func direction_set(value:Vector2) -> void:
	self.braking = false
	if value.y <= 0:
		value.y = 0
		if value.x == 0: value.x = 1.0 # Make sure it's not all 0
		self.braking = true
	_direction = value
	self._force = _direction.dot(DOWN) * dh_force
#endregion

#region drag
func drag_get() -> float:
	if self.braking: return self.braking_drag
	return self.running_drag
#endregion

#region index
func d_index_set(value:int) -> void:
	var old := _d_index
	_d_index = value
	if old != value: self.calc_sprite()
#endregion

#region sprite determination - movement
func calc_sprite() -> void:
	var s = SPRITE_INDEX[self._d_index]
	sprite_sheet.frame = s[0]
	sprite_sheet.flip_h = s[1]
#endregion

#region signal helpers
func rock_crash() -> void:
	sprite_sheet.animation = "crash_anim"
	sprite_sheet.frame = 2
	sprite_sheet.flip_h = false
	change_state(SkiState.CRASH)
	get_tree().paused = true
#endregion

#region signal helpers
func tree_crash(col: Node2D) -> void:
	if _state == SkiState.GROUND:
		sprite_sheet.animation = "crash_anim"
		sprite_sheet.frame = 2
		sprite_sheet.flip_h = false
		change_state(SkiState.CRASH)
		get_tree().paused = true
		
#region end

func handle_collision(col: Node2D) -> void:
	if col is ROCK:
		rock_crash()
	
	if col is TREE:
		tree_crash(col)
		
	if col is JUMP:
		ski_jump()

func ski_jump() -> void:
	change_state(SkiState.JUMPED)
	ski_col.disabled = true
	air_timer.start(1)
	sprite_sheet.play("jump_anim")
	sprite_sheet.scale.x = 1.5
	sprite_sheet.scale.y = 1.5
	
	

func restore_collision()-> void:
	self.collision_layer = 1
	change_state(SkiState.GROUND)
#region state_change
func change_state(new_state: SkiState) -> void:
	if _state == new_state:
		return
#endregion


func _on_air_timer_timeout() -> void:
	sprite_sheet.stop()
	sprite_sheet.scale.x = 1
	sprite_sheet.scale.y = 1
	change_state(SkiState.GROUND)
	sprite_sheet.animation = "ski_anim"
	calc_sprite()
	ski_col.disabled = false
	
