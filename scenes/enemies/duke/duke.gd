extends CharacterBody2D
class_name DUKE

enum DukeState {SLOW, FAST, EAT}

@export var move_speed: float = 150.0
@export var max_speed: float = 350.0
@export var speed_incrase: float = 0.5


#region Duke Onready
@onready var collison_shape_sidways: CollisionShape2D = $CollisonShapeSidways
@onready var collision_front: CollisionShape2D = $CollisionFront
@onready var duke_sheet: AnimatedSprite2D = $DukeSheet
@onready var speed_timer: Timer = $speed_timer

#endregion

@onready var skiier: CharacterBody2D = $"../skiier"

var _state: DukeState = DukeState.SLOW

func _ready() -> void:
	self.collison_shape_sidways.disabled = true
	duke_sheet.play("duke_swim_front")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _state == DukeState.EAT:
		return
	velocity = determine_velocity()
	move_and_slide()
	handle_sprite_flip()
	
	for i in range(get_slide_collision_count()):
		handle_collision(get_slide_collision(i).get_collider())

func determine_velocity() -> Vector2:
	return get_direction() * get_state_speed()

func get_direction() -> Vector2:
	return (skiier.global_position - global_position).normalized()

func handle_sprite_flip() -> void:
	var dir = get_direction()
	if dir.x < 0:
		duke_sheet.flip_h = true
	if dir.x > 0:
		duke_sheet.flip_h = false

func get_state_speed() -> float:
	if _state == DukeState.FAST && move_speed <= max_speed:
		move_speed += speed_incrase
	return move_speed

func change_state(new_state: DukeState) -> void:
	if new_state == _state:
		return
	
	_state = new_state
	change_speed()
	
func change_speed() -> void:
	match _state:
		DukeState.SLOW:
			self.collision_front.disabled = false
			self.collison_shape_sidways.disabled = true
		DukeState.FAST:
			self.collision_front.disabled = true
			self.collison_shape_sidways.disabled = false
			duke_sheet.play("duke_swim_sideways")


func _on_speed_timer_timeout() -> void:
	change_state(DukeState.FAST)
	
func play_eat_sprite() -> void:
	duke_sheet.play("duke_eat")
	change_state(DukeState.EAT)

func _on_duke_sheet_animation_finished() -> void:
	if duke_sheet.animation == "duke_eat" && duke_sheet.frame == 7:
		duke_sheet.frame = 0

func handle_collision(col: Node2D) -> void:
	if col is MIKU:
		_state = DukeState.EAT
		play_eat_sprite()
		SignalHub.emit_on_duke_eat()
		SignalHub.emit_game_over()
	return
