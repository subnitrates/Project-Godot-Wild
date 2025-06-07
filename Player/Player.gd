class_name Player
extends CharacterBody2D

var dash_cooldown_timer := 0.0
var is_shooting: bool = false
var current_state: PlayerState

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hover_gun = $HoverGun
@onready var player_stats = $PlayerStats
@onready var hp_bar: TextureProgressBar = %HPBar
@onready var stamina_bar: TextureProgressBar = %StaminaBar


func _ready() -> void:
	current_state = PlayerIdleState.new()
	current_state.player = self
	current_state.enter() 
	player_stats.health_changed.connect(_on_player_health_changed)
	player_stats.player_died.connect(_on_player_died)
	hp_bar.max_value = player_stats.max_health
	hp_bar.value = player_stats.health
	stamina_bar.value = player_stats.stamina
	stamina_bar.max_value = player_stats.max_stamina

func _physics_process(delta: float) -> void:
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	stamina_bar.value = player_stats.stamina
	current_state.update(delta)
	hover_gun.update_position(global_position, get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		hover_gun.shoot()

func _input(event: InputEvent) -> void:
	current_state.handle_input(event)
	if event.is_action_pressed("shoot"):
		is_shooting = true
	elif event.is_action_released("shoot"):
		is_shooting = false

func change_state(new_state_instance: PlayerState):
	if current_state:
		current_state.exit()
	
	current_state = new_state_instance
	current_state.player = self
	current_state.enter()

func take_damage(amount: int):
	player_stats.take_damage(amount)
	hp_bar.max_value = player_stats.max_health
	hp_bar.value = player_stats.health
	# can add some visual or audio here later?

func use_stamina(amount: int):
	return player_stats.use_stamina(amount) 
	stamina_bar.value = player_stats.stamina
	stamina_bar.max_value = player_stats.max_stamina
	# add visuals here too?

func add_coins(amount: int):
	player_stats.add_coins(amount)

func _on_player_died():
	# add some on death code here?
	queue_free()

func _on_player_health_changed(old, new): 
	print("Health changed from ", old, " to ", new)

func get_input_direction() -> Vector2: 
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
