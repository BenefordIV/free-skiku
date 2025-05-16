extends Node2D

@export var spawn_scene : PackedScene
@export var density : float = 5.0
@export var obj_w : int = 1
@export var obj_h : int = 1
@export var start_x : int = 0
@export var generate_width : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func generate(region:TileGenerator) -> void:
	if generate_width < 0: 
		generate_width = region.width - start_x
	region.spawn_objects_area(spawn_scene, density/1000.0, start_x, region.origin_y, generate_width, region.height, obj_w, obj_h)
	pass
