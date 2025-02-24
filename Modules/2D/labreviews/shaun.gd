extends Sprite2D

@export var sheep_name =  "shaun"
@export var speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("baaaaahh im "+sheep_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(Input.is_action_pressed("ui_down"))
	if Input.is_action_pressed("down"):
		position.y += speed
	if Input.is_action_pressed("up"):
		position.y -= speed
	if Input.is_action_pressed("left"):
		position.x -= speed
	if Input.is_action_pressed("right"):
		position.x += speed
	if Input.is_action_just_pressed("jump"):
		print('i jumped')
