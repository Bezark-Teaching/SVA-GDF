extends CharacterBody2D

var accel = 7
const SPEED = 250.0

@onready var navigation_agent_2d = $NavigationAgent2D

func _ready():
	navigation_agent_2d.target_position = $"../Player".position


func _physics_process(delta):
	navigation_agent_2d.target_position = $"../Player".position
	
	var direction = Vector3()
	
	direction = navigation_agent_2d.get_next_path_position() - global_position
	print(direction)
	direction = direction.normalized()
	print(direction)
	velocity = velocity.lerp(direction*SPEED, accel*delta)
	
	
	move_and_slide()
