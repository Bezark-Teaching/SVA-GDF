extends Node2D

@export var possible_foods : Array[String]

const FOOD = preload("res://food.tscn")

func _ready():
	var new_food = FOOD.instantiate()
	new_food.food_name = possible_foods.pick_random()
	add_child(new_food)
