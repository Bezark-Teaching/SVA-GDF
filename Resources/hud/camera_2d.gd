extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position+Vector2(1200, 100), 5)


		
