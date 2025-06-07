class_name PlayerMoveState
extends PlayerState

func enter():
	if player.animated_sprite_2d:
		player.animated_sprite_2d.play("run") 
	else:
		print("PlayerMoveState: couldn't play run animation")

func exit():
	pass

func update(delta:float):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("dash") and player.dash_cooldown_timer <= 0:
		if player.use_stamina(GameConstants.DASH_COST):
			transition_to(PlayerDashState.new())
		else:
			print("Not enough stamina to dash!")
	elif input_direction == Vector2.ZERO:
		transition_to(PlayerIdleState.new())
	else:
		player.velocity = input_direction.normalized() * GameConstants.PLAYER_BASE_SPEED
		
		if player.animated_sprite_2d:
			if input_direction.x > 0:
				player.animated_sprite_2d.flip_h = false 
			elif input_direction.x < 0:
				player.animated_sprite_2d.flip_h = true
	
	player.move_and_slide()
