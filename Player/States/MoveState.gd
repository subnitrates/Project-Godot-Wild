class_name PlayerMoveState
extends PlayerState

const SPEED: float = 400.0

func enter():
	if player.animated_sprite_2d:
		player.animated_sprite_2d.play("run") 
	else:
		print("PlayerMoveState: couldn't play run animation")

func exit():
	pass

func update(delta:float):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_direction == Vector2.ZERO:
		transition_to(PlayerIdleState.new())
	else:
		player.velocity = input_direction.normalized() * SPEED
		
		if player.animated_sprite_2d:
			if input_direction.x > 0:
				player.animated_sprite_2d.flip_h = false 
			elif input_direction.x < 0:
				player.animated_sprite_2d.flip_h = true
	
	player.move_and_slide()
