class_name PlayerIdleState
extends PlayerState

func enter():
	if player.animated_sprite_2d:
		player.animated_sprite_2d.play("idle")
	else:
		printerr("PlayerIdleState: Couldn't play idle animation")

func update(delta: float):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("dash") and player.dash_cooldown_timer <= 0:
		if player.use_stamina(player.DASH_COST):
			transition_to(PlayerDashState.new())
		else:
			print("Not enough stamina to dash!")
	elif input_direction != Vector2.ZERO:
		transition_to(PlayerMoveState.new())
