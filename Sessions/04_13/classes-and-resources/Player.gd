extends Node2D


@export var held_item : Item


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		held_item.use()
