extends Path2D
@export var speed = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PathFollow2D.progress_ratio += speed


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
