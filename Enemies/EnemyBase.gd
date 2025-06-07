# EnemyBase.gd
# This is the base class for all enemies. It handles the core logic for states,
# movement, and player detection that all enemies will share.
extends CharacterBody2D
class_name EnemyBase

# --- Enums and Signals ---
enum EnemyState { IDLE, WANDERING, CHASING }
signal health_depleted

@export var enemy_type: String = "DEFAULT"


# --- Nodes ---
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detection: Area2D = $PlayerDetection
@onready var state_timer: Timer = $StateTimer 
@onready var hp_bar: Node2D = $HpBar if has_node("HpBar") else null

# --- State Variables ---
var current_health: int
var current_state: EnemyState = EnemyState.IDLE
var player_ref: Player 
var min_idle_time: float
var max_idle_time: float
var wander_distance: float
var max_health: int
var wander_speed: float
var chase_speed: float
var experience_reward: int

# --- Private Variables ---
var _wander_target_pos := Vector2.ZERO

# --- Engine Functions ---
func _ready() -> void:
	var stats = GameConstants.EnemyStats.get(enemy_type)
	if not stats:
		push_warning("Enemy stats for type '%s' not found! Using DEFAULT." % enemy_type)
		stats = GameConstants.EnemyStats.DEFAULT

	max_health = stats.max_health
	wander_speed = stats.wander_speed
	chase_speed = stats.chase_speed
	wander_distance = stats.wander_distance
	min_idle_time = stats.min_idle_time
	max_idle_time = stats.max_idle_time
	experience_reward = stats.xp_reward
	current_health = max_health
	
	player_detection.body_entered.connect(_on_player_spotted)
	player_detection.body_exited.connect(_on_player_lost)
	state_timer.timeout.connect(_on_state_timer_timeout)
	health_depleted.connect(_on_health_depleted)
	if hp_bar:
		hp_bar.update_bar(current_health, max_health)

	call_deferred("set_state", EnemyState.IDLE)

func _physics_process(delta: float) -> void:
	match current_state:
		EnemyState.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
		
		EnemyState.WANDERING:
			var direction_to_wander = global_position.direction_to(_wander_target_pos)
			velocity = velocity.move_toward(direction_to_wander * wander_speed, 100 * delta)
			
			# Check if we've reached the destination or hit a wall
			if global_position.distance_to(_wander_target_pos) < 5.0 or is_on_wall():
				set_state(EnemyState.IDLE)

		EnemyState.CHASING:
			if not is_instance_valid(player_ref):
				set_state(EnemyState.IDLE)
				return
			
			var direction_to_player = global_position.direction_to(player_ref.global_position)
			velocity = velocity.move_toward(direction_to_player * chase_speed, 150 * delta)
	
	move_and_slide()
	# Flip sprite based on movement direction
	if abs(velocity.x) > 1:
		sprite.flip_h = velocity.x < 0

# --- State Machine ---
func set_state(new_state: EnemyState) -> void:
	if current_state == new_state:
		return

	# Exit the current state to clean up timers and logic
	match current_state:
		EnemyState.WANDERING:
			state_timer.stop() # Stop wander timeout if interrupted
	
	# Enter the new state
	match new_state:
		EnemyState.IDLE:
			state_timer.start(randf_range(min_idle_time, max_idle_time))

		EnemyState.WANDERING:
			var random_direction = Vector2.from_angle(randf_range(0, TAU))
			_wander_target_pos = global_position + random_direction * randf_range(wander_distance * 0.5, wander_distance)
			# Set a fallback timeout in case the enemy gets stuck
			state_timer.start(5.0) 

		EnemyState.CHASING:
			state_timer.stop() 
	
	current_state = new_state

# --- Public Functions ---
func take_damage(damage_amount: int) -> void:
	current_health = max(0, current_health - damage_amount)
	if hp_bar:
		hp_bar.update_bar(current_health, max_health)

	if current_health == 0:
		health_depleted.emit()

# --- Signal Callbacks ---
func _on_state_timer_timeout() -> void:
	if current_state == EnemyState.IDLE:
		set_state(EnemyState.WANDERING)
	elif current_state == EnemyState.WANDERING:
		# Fallback triggered (enemy likely got stuck)
		set_state(EnemyState.IDLE)

func _on_player_spotted(body: Node2D) -> void:
	if body is Player:
		player_ref = body
		set_state(EnemyState.CHASING)

func _on_player_lost(body: Node2D) -> void:
	if body == player_ref:
		player_ref = null
		set_state(EnemyState.IDLE)

func _on_health_depleted() -> void:
	var player_nodes = get_tree().get_nodes_in_group("player")
	if not player_nodes.is_empty() and player_nodes[0].has_method("add_experience"):
		player_nodes[0].add_experience(experience_reward)
	
	queue_free()
