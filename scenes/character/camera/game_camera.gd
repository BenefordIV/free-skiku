extends Camera2D

class_name GAME_CAMERA

const LINK = preload("res://scenes/enemies/link/link.tscn")

@export var mark_u: Marker2D
@export var mark_x_u: Marker2D
@export var mark_l: Marker2D

func _on_side_wall_l_body_entered(body: Node2D) -> void:
	if body is LINK:
		print("left")
		body.queue_free()


func _on_top_wall_body_entered(body: Node2D) -> void:
	if body is LINK:
		print("up")
		body.queue_free()


func _on_side_wall_r_body_entered(body: Node2D) -> void:
	if body is LINK:
		print("right")
		body.queue_free()
