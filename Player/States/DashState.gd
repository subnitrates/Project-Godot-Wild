class_name PlayerDashState
extends PlayerState

var dash_direction: Vector2
var dash_timer: float
var initial_velocity: Vector2 

func enter():
	dash_direction = player.get_input_direction()
	if dash_direction == Vector2.ZERO:
		dash_direction = player.velocity.normalized()
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2.RIGHT 
			
	dash_timer = player.dash_duration
	
	player.animated_sprite_2d.modulate = Color(0.7, 0.7, 1.0, 0.8)
	initial_velocity = player.velocity

func exit():
	player.animated_sprite_2d.modulate = Color.WHITE
	player.dash_cooldown_timer = player.dash_cooldown

func update(delta: float):
	dash_timer -= delta
	if dash_timer <= 0:
		if player.get_input_direction() != Vector2.ZERO:
			transition_to(PlayerMoveState.new())
		else:
			transition_to(PlayerIdleState.new())
	else:
		player.velocity = dash_direction * player.speed * player.dash_speed_multiplier
		player.move_and_slide()

func handle_input(event: InputEvent):
	pass
