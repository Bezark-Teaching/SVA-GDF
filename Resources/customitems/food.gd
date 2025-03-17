extends Node2D

@export var food_name : String





func _ready():
	$Icon.play(food_name)

func _on_area_2d_input_event(viewport, event, shape_idx):

	if event is InputEventMouseButton:
		if event.pressed:
			print(event)
			$"../..".food_added(food_name)
