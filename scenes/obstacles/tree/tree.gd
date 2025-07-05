extends StaticBody2D

class_name TREE

@onready var gc: CollisionPolygon2D = $GroundCollision
@onready var ac: CollisionPolygon2D = $AirCollision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 1
	ac.disabled = true
	pass # Replace with function body.


func _enter_tree() -> void:
	SignalHub.on_miku_jump.connect(_on_miku_jump)
	SignalHub.on_miku_land.connect(_on_miku_land)
	SignalHub.on_gg_crash.connect(_delete_gg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_miku_jump(node: Node2D) -> void:
	gc.disabled = true
	ac.disabled = false

func _on_miku_land() -> void:
	gc.disabled = false
	ac.disabled = true

func _delete_gg(gg: GG) -> void:
	gg.queue_free()
