extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	# Add the gravity.
	if Input.is_action_pressed("dash") and $DashBar.value >0:
		$DashBar.value -= 1
		SPEED = 900
		$Timer.start()
	else:
		$DashBar.value += 1
		SPEED = 300
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		

	move_and_slide()


func _on_timer_timeout():
	$DashBar.value = 100
