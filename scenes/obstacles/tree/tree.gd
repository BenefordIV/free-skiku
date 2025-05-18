extends StaticBody2D

class_name TREE

@onready var gc: CollisionPolygon2D = $GroundCollision
@onready var ac: CollisionPolygon2D = $AirCollision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gc.disabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
