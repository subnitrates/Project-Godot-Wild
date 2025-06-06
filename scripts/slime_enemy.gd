extends CharacterBody2D

enum EnemyStates {
	IDLE,
	WANDERING,
	CHASING
}

@export var min_idle_time: float = 0.5 
@export var max_idle_time: float = 1.5 
@export var wander_distance: float = 50
@export var max_health: int = 5
@export var wander_move_speed: int = 50 ## The speed of this enemy when they're wandering about, in pixels/sec
@export var chase_move_speed: int = 50 ## The speed of this enemy when they're chasing the player, in pixels/sec

@onready var sprite_anim_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_location: Marker2D = $SpawnLocation
@onready var player_detection: Area2D = $PlayerDetection
@onready var can_wander_raycast: RayCast2D = $CanWanderDetection
@onready var slime_enemy_collision: CollisionShape2D = $CollisionShape2D
@onready var curr_health: int = max_health
@onready var idle_timer: Timer = Timer.new()
@onready var wander_timer: Timer = Timer.new()

var curr_enemy_state: EnemyStates = EnemyStates.IDLE
var player_to_chase: CharacterBody2D
var wander_pos_to: Vector2 = Vector2.ZERO

signal wander_timeout

func _ready() -> void:
	curr_health = max_health
	
	idle_timer.one_shot = true
	add_child(idle_timer)
	idle_timer.timeout.connect(_on_idle_timeout) 

	wander_timer.one_shot = true
	add_child(wander_timer)
	wander_timer.timeout.connect(_on_wander_target_reached_or_timeout) 
	
	player_detection.body_entered.connect(_on_player_spotted)
	player_detection.body_exited.connect(_on_player_lost)
	
	call_deferred("_enter_idle_state")

func _physics_process(_delta: float) -> void: 
	match curr_enemy_state:
		EnemyStates.CHASING:
			_chase_player()
		EnemyStates.WANDERING:
			_wander_to_pos()
		EnemyStates.IDLE:
			pass

func _enter_idle_state() -> void:
	curr_enemy_state = EnemyStates.IDLE
	idle_timer.wait_time = randf_range(min_idle_time, max_idle_time)
	idle_timer.start()

func _on_idle_timeout() -> void:
	_enter_wandering_state()

func _enter_wandering_state() -> void:
	curr_enemy_state = EnemyStates.WANDERING

	wander_pos_to = global_position + Vector2(randf_range(-wander_distance, wander_distance), randf_range(-wander_distance, wander_distance))
	
	var distance_to_target = global_position.distance_to(wander_pos_to)
	var time_to_reach_target = distance_to_target / wander_move_speed
	wander_timer.wait_time = time_to_reach_target + 0.5 
	wander_timer.start()

func _wander_to_pos() -> void:
	if curr_enemy_state != EnemyStates.WANDERING:
		return
	
	velocity = global_position.direction_to(wander_pos_to) * wander_move_speed
	move_and_slide()

	if global_position.distance_to(wander_pos_to) <= 2 or is_on_wall():
		_on_wander_target_reached_or_timeout() 

func _on_wander_target_reached_or_timeout() -> void:
	wander_timer.stop()
	_enter_idle_state()

func _chase_player() -> void:
	if not player_to_chase:
		curr_enemy_state = EnemyStates.IDLE
		return
	
	var chase_dir: Vector2 = (player_to_chase.global_position - self.global_position).normalized()
	velocity = chase_dir * chase_move_speed
	move_and_slide()

func _on_player_spotted(player: Node2D) -> void:
	if not player is Player: return
	if curr_enemy_state == EnemyStates.CHASING: return
	
	idle_timer.stop()
	wander_timer.stop()
	
	player_to_chase = player
	print("player spotted!")
	curr_enemy_state = EnemyStates.CHASING

func _on_player_lost(body: Node2D) -> void:
	if body == player_to_chase:
		player_to_chase = null
		call_deferred("_enter_idle_state")

func take_damage(damage_amount: int) -> void:
	curr_health -= damage_amount
	if curr_health <= 0:
		print("slime enemy died!")
		queue_free()
