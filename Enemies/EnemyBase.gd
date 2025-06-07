# EnemyBase.gd
# This is the base class for all enemies. It handles the core logic for states,
# movement, and player detection that all enemies will share.
extends CharacterBody2D
class_name EnemyBase

# --- Enums and Signals ---
enum EnemyStates {
	IDLE,
	WANDERING,
	CHASING
}
signal health_depleted

# --- Exports ---
@export var min_idle_time: float = GameConstants.ENEMY_DEFAULT_MIN_IDLE_TIME
@export var max_idle_time: float = GameConstants.ENEMY_DEFAULT_MAX_IDLE_TIME
@export var wander_distance: float = GameConstants.ENEMY_DEFAULT_WANDER_DISTANCE
@export var max_health: int = GameConstants.ENEMY_DEFAULT_MAX_HEALTH
@export var wander_move_speed: int = GameConstants.ENEMY_DEFAULT_WANDER_SPEED
@export var chase_move_speed: int = GameConstants.ENEMY_DEFAULT_CHASE_SPEED

# --- OnReady Variables ---
@onready var sprite_anim_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detection: Area2D = $PlayerDetection
@onready var idle_timer: Timer = $IdleTimer 
@onready var wander_timer: Timer = $WanderTimer

# --- State Variables ---
var current_health: int
var current_enemy_state: EnemyStates = EnemyStates.IDLE
var player_to_chase: CharacterBody2D
var wander_pos_to: Vector2 = Vector2.ZERO

# --- Engine Functions ---
func _ready() -> void:
	current_health = max_health
	
	idle_timer.timeout.connect(_on_idle_timeout)
	wander_timer.timeout.connect(_on_wander_target_reached_or_timeout)
	player_detection.body_entered.connect(_on_player_spotted)
	player_detection.body_exited.connect(_on_player_lost)
	health_depleted.connect(_on_health_depleted)

	call_deferred("_enter_idle_state")

func _physics_process(_delta: float) -> void:
	match current_enemy_state:
		EnemyStates.CHASING:
			_chase_player()
		EnemyStates.WANDERING:
			_wander_to_pos()
		EnemyStates.IDLE:
			velocity = Vector2.ZERO 
	
	move_and_slide()

# --- State Management ---
func _enter_idle_state() -> void:
	current_enemy_state = EnemyStates.IDLE
	idle_timer.wait_time = randf_range(min_idle_time, max_idle_time)
	idle_timer.start()

func _enter_wandering_state() -> void:
	current_enemy_state = EnemyStates.WANDERING
	
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_pos_to = global_position + random_direction * wander_distance
	
	var distance_to_target = global_position.distance_to(wander_pos_to)
	var time_to_reach_target = distance_to_target / wander_move_speed
	wander_timer.wait_time = time_to_reach_target + 0.5 
	wander_timer.start()

# --- State Logic ---
func _wander_to_pos() -> void:
	if current_enemy_state != EnemyStates.WANDERING:
		return
	
	velocity = global_position.direction_to(wander_pos_to) * wander_move_speed

	if global_position.distance_to(wander_pos_to) <= 2 or is_on_wall():
		_on_wander_target_reached_or_timeout()

func _chase_player() -> void:
	if not is_instance_valid(player_to_chase):
		_enter_idle_state()
		return
	
	var chase_dir: Vector2 = (player_to_chase.global_position - self.global_position).normalized()
	velocity = chase_dir * chase_move_speed

# --- Signal Callbacks ---
func _on_idle_timeout() -> void:
	_enter_wandering_state()

func _on_wander_target_reached_or_timeout() -> void:
	wander_timer.stop()
	_enter_idle_state()

func _on_player_spotted(body: Node2D) -> void:
	if not body is Player: return # checks for player class
	if current_enemy_state == EnemyStates.CHASING: return
	
	idle_timer.stop()
	wander_timer.stop()
	
	player_to_chase = body
	current_enemy_state = EnemyStates.CHASING

func _on_player_lost(body: Node2D) -> void:
	if body == player_to_chase:
		player_to_chase = null
		call_deferred("_enter_idle_state")

func _on_health_depleted() -> void:
	queue_free()

# --- Public Functions ---
func take_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	if current_health <= 0:
		health_depleted.emit()
