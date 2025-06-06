extends CharacterBody2D

@onready var sprite_anim_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_location: Marker2D = $SpawnLocation
@onready var player_detection: Area2D = $PlayerDetection
@onready var can_wander_raycast: RayCast2D = $CanWanderDetection

enum EnemyStates {
	IDLE,
	WANDERING,
	CHASING
}

var curr_enemy_state: EnemyStates = EnemyStates.IDLE
var prev_enemy_state: EnemyStates = EnemyStates.IDLE

var player_to_chase: CharacterBody2D

@export var max_health: int = 5
@export var wander_move_speed: int = 25 ## The speed of this enemy when they're wandering about, in pixels/sec
@export var chase_move_speed: int = 50 ## The speed of this enemy when they're chasing the player, in pixels/sec

@onready var curr_health: int = max_health

signal _on_wander_timeout

var wander_pos_to: Vector2 = Vector2.ZERO
@onready var idle_timer: Timer = Timer.new()


func _ready() -> void:
	player_detection.body_entered.connect(_on_player_spotted)
	self.add_child(idle_timer)
	_enter_idle_state()


func _process(_delta: float) -> void:
	match curr_enemy_state:
		EnemyStates.CHASING:
			_chase_player()
		EnemyStates.IDLE when prev_enemy_state == EnemyStates.WANDERING:
			_enter_idle_state()
		EnemyStates.IDLE when prev_enemy_state == EnemyStates.IDLE:
			_process_idle_state()
		EnemyStates.WANDERING when prev_enemy_state == EnemyStates.IDLE:
			_enter_wandering_state()
		EnemyStates.WANDERING when prev_enemy_state == EnemyStates.WANDERING:
			_process_wandering_state()
	prev_enemy_state = curr_enemy_state


func _enter_idle_state() -> void:
	idle_timer.wait_time = 0.1
	idle_timer.start()


func _process_idle_state() -> void:
	await idle_timer.timeout
	curr_enemy_state = EnemyStates.WANDERING


func _enter_wandering_state() -> void:
	wander_pos_to = self.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	
	if self.is_on_wall():
		while wander_pos_to.normalized().dot(self.get_wall_normal()) <= -0.6:
			DebugDraw2D.line(self.global_position, self.global_position + can_wander_raycast.target_position, Color.RED, 1, 2.5)
			wander_pos_to = self.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))

		self.velocity = self.get_wall_normal() * 2
		move_and_slide()


func _process_wandering_state() -> void:
	_wander_to_pos()
	await _on_wander_timeout
	curr_enemy_state = EnemyStates.IDLE


func _wander_to_pos() -> void:
	if self.is_on_wall():
		curr_enemy_state = EnemyStates.IDLE
		return

	velocity = self.global_position.direction_to(wander_pos_to) * wander_move_speed

	move_and_slide()

	if self.global_position.distance_to(wander_pos_to) <= 1:
		_on_wander_timeout.emit()


func _chase_player() -> void:
	if not player_to_chase:
		push_error("PLAYER IS NULL, THIS SHOULD NEVER HAPPEN")
		curr_enemy_state = EnemyStates.IDLE
		return
	
	var chase_dir: Vector2 = (player_to_chase.global_position - self.global_position).normalized()
	velocity = chase_dir * chase_move_speed
	move_and_slide()


func _on_player_spotted(player: Node2D) -> void:
	if not player is Player: return
	if curr_enemy_state == EnemyStates.CHASING: return
	if player_to_chase == player: return
	player_to_chase = player
	print("player spotted!")
	curr_enemy_state = EnemyStates.CHASING


func on_damaged(damage_amount: int) -> void:
	if curr_health - damage_amount >= 0:
		print("slime enemy died!")
		return
	
	curr_health -= damage_amount
