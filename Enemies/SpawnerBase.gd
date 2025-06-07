extends StaticBody2D
class_name SpawnerBase

signal health_depleted

@export var enemy_scene: PackedScene
@export var spawn_count: int = GameConstants.SPAWNER_DEFAULT_SPAWN_COUNT
@export var max_enemies: int = GameConstants.SPAWNER_DEFAULT_MAX_ENEMIES
@export var spawn_radius: float = GameConstants.SPAWNER_DEFAULT_SPAWN_RADIUS
@export var spawn_interval_secs: float = GameConstants.SPAWNER_DEFAULT_SPAWN_INTERVAL
@export var max_health: int = GameConstants.SPAWNER_DEFAULT_MAX_HEALTH

@onready var hp_bar: Node2D = $HpBar
@onready var spawn_timer: Timer = $SpawnTimer
@onready var activation_area: Area2D = $ActivationArea
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var spawned_enemies: Array[Node] = []
var current_health: int

func _ready() -> void:
	current_health = max_health
	hp_bar.update_bar(current_health, max_health)

	spawn_timer.wait_time = spawn_interval_secs
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	activation_area.body_entered.connect(_on_player_entered_activation_area)
	activation_area.body_exited.connect(_on_player_exited_activation_area)
	health_depleted.connect(_on_health_depleted)

func _spawn_enemies() -> void:
	if not enemy_scene:
		push_warning("SpawnerBase: Enemy scene not set. Cannot spawn.")
		return

	spawned_enemies = spawned_enemies.filter(is_instance_valid)

	var enemies_to_spawn = min(spawn_count, max_enemies - spawned_enemies.size())
	if enemies_to_spawn <= 0:
		return

	for i in range(enemies_to_spawn):
		var enemy_instance: Node2D = enemy_scene.instantiate()
		var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		enemy_instance.global_position = global_position + random_direction * randf_range(0, spawn_radius)
		enemy_instance.tree_exited.connect(_on_enemy_removed.bind(enemy_instance))

		get_parent().add_child(enemy_instance)
		spawned_enemies.append(enemy_instance)

func _on_enemy_removed(enemy: Node) -> void:
	if spawned_enemies.has(enemy):
		spawned_enemies.erase(enemy)

func take_damage(damage_amount: int) -> void:
	current_health = max(0, current_health - damage_amount)
	hp_bar.update_bar(current_health, max_health)

	if current_health <= 0:
		health_depleted.emit()

func _on_health_depleted() -> void:
	spawn_timer.stop()
	# sound or fx?
	queue_free()

func _on_spawn_timer_timeout() -> void:
	_spawn_enemies.call_deferred()

func _on_player_entered_activation_area(body: Node2D) -> void:
	if body.is_in_group("player"):
		spawn_timer.start()
		_spawn_enemies.call_deferred()

func _on_player_exited_activation_area(body: Node2D) -> void:
	if body.is_in_group("player"):
		spawn_timer.stop()

func _on_enemy_exited_tree(enemy: Node) -> void:
	var index = spawned_enemies.find(enemy)
	if index != -1:
		spawned_enemies.remove_at(index)
