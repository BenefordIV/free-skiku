extends Camera2D

class_name GAME_CAMERA

const LINK = preload("res://scenes/enemies/link/link.tscn")

@export var mark_u: Marker2D
@export var mark_x_u: Marker2D
@export var mark_l: Marker2D
@export var mark_lift_spawn_min: Marker2D
@export var mark_lift_spawn_max: Marker2D

func _on_side_wall_l_body_entered(body: Node2D) -> void:
	if body is LINK:
		body.queue_free()
	if body is CHAIR_LIFT:
		SignalHub.emit_on_ski_lift_despawn()

func _on_top_wall_body_entered(body: Node2D) -> void:
	if body is LINK:
		body.queue_free()
	if body is CHAIR_LIFT:
		SignalHub.emit_on_ski_lift_despawn()

func _on_side_wall_r_body_entered(body: Node2D) -> void:
	if body is LINK:
		body.queue_free()
	if body is CHAIR_LIFT:
		SignalHub.emit_on_ski_lift_despawn()
