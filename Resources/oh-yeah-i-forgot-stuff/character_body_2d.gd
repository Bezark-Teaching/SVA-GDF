extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var attacking = false

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	
	if not attacking:
		if direction:
			if direction == -1:
				$Animations.flip_h = true
			else:
				$Animations.flip_h = false
			velocity.x = direction * SPEED
			$Animations.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$Animations.play("default")

	if Input.is_action_just_pressed("attack"):
		$Animations.play("attack")
		attacking = true
	#if Input.is_action_pressed("ui_left"):
		#velocity.x = -100
	#elif Input.is_action_pressed("ui_right"):
		#velocity.x = 100
	#elif Input.is_action_pressed("ui_up"):
		#velocity.y = -100
	#elif Input.is_action_pressed("ui_down"):
		#velocity.y = 100
	#else:
		#velocity = Vector2(0,0)
		
	move_and_slide()


func _on_animations_animation_finished():
	if $Animations.animation == "attack":
		attacking =false
