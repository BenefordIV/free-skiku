class_name TileGenerator

extends Node2D

var blocked := []
var width : int
var height : int
var tile_width : float
var tile_height : float
var origin_x : int
var origin_y: int

func _init (x:int, y:int, w:int, h:int, tw:float, th:float) -> void: 
	self.origin_x = x
	self.origin_y = y
	self.width = w
	self.height = h
	self.tile_width = tw
	self.tile_height = th
	self.blocked.resize(w*h)
	pass

func spawn_objects(obj:PackedScene, density:float, ow:int, oh:int) -> void:
	self.spawn_objects_area(obj, density, self.origin_x, self.origin_y, self.width, self.height, ow, oh)
	
func spawn_objects_area(obj:PackedScene, denisty:float, x:int, y:int, rw:int, rh:int, ow:int, oh:int) -> void:
	var n = int((rw*rh) * denisty)
	
	for i in range(n):
		var placed := false
		while !placed:
			var eff_w := rw - (ow - 1)
			var eff_h := rh - (oh - 1)
			var px := x + (randi() % eff_w)
			var py := y +(randi() % eff_h)
			placed = self.add_object(obj, px, py, ow, oh)

func add_object(obj:PackedScene, x:int, y:int, w:int, h:int) -> bool :
	if self.is_region_blocked(x, y, w, h): return false
	self.block_region(x, y, w, h)
	var node = obj.instantiate() as Node2D
	node.position = Vector2((x-self.origin_x)*self.tile_width, (y-self.origin_y)*self.tile_height)
	self.add_child(node)
	return true
	
func block_region(x:int, y:int, w:int, h:int) -> void:
	for iy in range(y, y+h):
		for ix in range(x, x+w):
			self.blocked[self.get_blocked_index(ix, iy)] = true
			
func is_region_blocked(x:int, y:int, w:int, h:int) -> bool:
	for iy in range(y, y+h):
		for ix in range(x, x+w):
			if self.blocked[self.get_blocked_index(ix, iy)]: return true
	return false

func get_blocked_index(x:int, y:int) -> int:
	return (y-self.origin_y) * self.width + (x-self.origin_x)
