class_name PlayerIdleState
extends PlayerState

func enter():
	if player.animated_sprite_2d:
		player.animated_sprite_2d.play("idle")
	else:
		printerr("PlayerIdleState: Couldn't play idle animation")


func update(delta: float):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction != Vector2.ZERO:
		transition_to(PlayerMoveState.new())
