extends Sprite2D
class_name Item

@export var title : String
@export var price : int
@export var picture: Texture


func use():
	print('you used ', title)
