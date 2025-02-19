extends Sprite2D

var my_var = 0

@export var speed = 2

#Called when the node enters the scene tree for the first time.
func _ready()-> void:
	print(position.x)
	print(position.y)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(my_var)
	#my_var = my_var + 1
	position.x = position.x + speed
	position.y += speed
