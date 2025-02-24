extends Sprite2D

var active = false
var my_array = [0, "strings", true]
# Called when the node enters the scene tree for the first time.
func _ready():
	for number in my_array:
		print(number)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if Input.is_action_pressed("ui_right"):
			position.x += 4


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		$"..".activeKnight = self
		
	#if event is InputEventMouseButton:
		#var knights = get_tree().get_nodes_in_group("knights")
		#for current_knight in knights:
			#if current_knight == self:
				#current_knight.active = true
			#else:
				#current_knight.active = false
				#
		
