extends Node2D

var bagels = ["bagel", "bagel","plate"]
var pizza = []

var our_picked_gredients = []

func _process(delta):
	pass

func food_added(new_food):
	our_picked_gredients.append(new_food)
	print(our_picked_gredients)
	
	for recipe in $Recipes.get_children():
		
		recipe.ingredients.sort()
		our_picked_gredients.sort()
		if our_picked_gredients == recipe.ingredients:
			print("you made a", recipe.name )
