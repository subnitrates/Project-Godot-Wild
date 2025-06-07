extends Node2D

@export var bullet_scene: PackedScene

var _target_position: Vector2 = Vector2.ZERO
var _shoot_cooldown: float = 0.0

func _ready():
	_shoot_cooldown = 1.0 / GameConstants.GUN_FIRE_RATE

	var tween = create_tween().set_loops()
	tween.tween_property(self, "scale", GameConstants.GUN_PULSE_SCALE, GameConstants.GUN_PULSE_DURATION)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), GameConstants.GUN_PULSE_DURATION)

func _physics_process(delta: float) -> void:
	_shoot_cooldown = max(_shoot_cooldown - delta, 0)
	global_position = global_position.lerp(_target_position, GameConstants.GUN_LERP_SPEED * delta)
	look_at(get_global_mouse_position())

func update_position(player_position: Vector2, mouse_position: Vector2) -> void:
	var direction = (mouse_position - player_position).normalized()
	_target_position = player_position + (direction * GameConstants.GUN_RADIUS)

func shoot() -> void:
	if _shoot_cooldown > 0:
		return

	_shoot_cooldown = 1.0 / GameConstants.GUN_FIRE_RATE

	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	# Set bullet's position and direction based on gun and mouse
	var muzzle_position = global_position + transform.x * GameConstants.GUN_MUZZLE_OFFSET.x
	bullet.global_position = muzzle_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = global_rotation

	apply_recoil()

func apply_recoil() -> void:
	# Apply recoil by offsetting position and adding slight random rotation
	var recoil_direction = -transform.x * GameConstants.GUN_RECOIL_STRENGTH
	global_position += recoil_direction
	rotation += randf_range(-0.05, 0.05)
