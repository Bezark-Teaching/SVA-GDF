extends NavigationAgent2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	target_position = $"../End".position
	get_next_path_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
