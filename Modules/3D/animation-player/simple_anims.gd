extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		$AnimationPlayer.play("sunset")


func sunset_is_over():
	print("good night!")
	$CSGBox3D.queue_free()
	
func change_scene():
	get_tree().change_scene_to_file("res://other_scene.tscn")
