extends CharacterBody2D
class_name LINK

enum LINK_STATE {LEFT, RIGHT}

@export var link_speed_x: float = -250.0
@onready var link_sheet: AnimatedSprite2D = $link_sheet

var y_origin: float
var y_offset: float = randf_range(25.0, 35.0)
var y_vel: float = randf_range(0.5, 1.5)

func _ready() -> void:
	y_origin = self.global_position.y
	self.velocity.y += y_vel
	self.velocity.x = link_speed_x
	link_sheet.play("fly")
	pass
	
func _physics_process(delta: float) -> void:
	if get_offset() >= y_offset:
		self.velocity.y -= y_vel
	else:
		self.velocity.y += y_vel
		
	move_and_slide()

	
func _enter_tree() -> void:
	SignalHub.on_flip_link_values.connect(flip_values)


func get_offset() -> float:
	return self.global_position.y - y_origin

func flip_values(flip: bool) -> void:
	print(flip)
	if flip:
		self.velocity.x = -link_speed_x
		link_sheet.flip_h = true
	else:
		self.velocity.x = link_speed_x
		link_sheet.flip_h = false
	
