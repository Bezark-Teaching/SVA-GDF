extends Control


# Called when the node enters the scene tree for the first time.


func _on_button_button_down():
	get_tree().change_scene_to_file("res://Main Menu.tscn")
