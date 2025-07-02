extends StaticBody2D

class_name STUMP

@onready var stump_col: CollisionShape2D = $stump_col

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _enter_tree() -> void:
	SignalHub.on_miku_jump.connect(disable_stump)
	SignalHub.on_miku_land.connect(enable_stump)
	SignalHub.on_gg_crash.connect(_delete_gg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func disable_stump(node: Node2D) -> void:
	stump_col.disabled = true
	
func enable_stump() -> void:
	stump_col.disabled = false

func _delete_gg(gg: GG) -> void:
	gg.queue_free()
