extends StaticBody2D

class_name ROCK

@onready var rock_col: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _enter_tree() -> void:
	SignalHub.on_miku_jump.connect(disable_rock)
	SignalHub.on_miku_land.connect(enable_rock)
	SignalHub.on_gg_crash.connect(_delete_gg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func disable_rock(node: Node2D) -> void:
	rock_col.disabled = true
	
func enable_rock() -> void:
	rock_col.disabled = false

func _delete_gg(gg: GG) -> void:
	gg.queue_free()
