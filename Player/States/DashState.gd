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
			dash_direction = GameConstants.DASH_DEFAULT_DIRECTION
	
	dash_timer = GameConstants.DASH_DURATION
	player.animated_sprite_2d.modulate = GameConstants.DASH_COLOR
	initial_velocity = player.velocity

func exit():
	player.animated_sprite_2d.modulate = Color.WHITE
	player.dash_cooldown_timer = GameConstants.DASH_COOLDOWN

func update(delta: float):
	dash_timer -= delta
	if dash_timer <= 0:
		transition_to_idle_or_move()
	else:
		apply_dash_movement()
		player.move_and_slide()

func transition_to_idle_or_move():
	if player.get_input_direction() != Vector2.ZERO:
		transition_to(PlayerMoveState.new())
	else:
		transition_to(PlayerIdleState.new())

func apply_dash_movement():
	var dash_speed = GameConstants.PLAYER_BASE_SPEED * GameConstants.DASH_SPEED_MULTIPLIER
	player.velocity = dash_direction * dash_speed

func handle_input(event: InputEvent):
	pass
