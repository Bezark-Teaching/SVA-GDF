extends Node2D


func _on_area_2d_body_entered(body):
	body.take_damage(1)
