extends Node2D

@export var radius: float = 10.0
@export var lerp_speed: float = 5.0
@export var bullet_scene: PackedScene
@export var fire_rate: float = 5
@export var recoil_strength: float = 5.0
@export var muzzle_offset: Vector2 = Vector2(20, 0)

var _target_position: Vector2 = Vector2.ZERO
var _shoot_cooldown: float = 0.0

func _ready():
	# pulsing effect
	var tween = create_tween().set_loops()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)

func _physics_process(delta: float) -> void:
	_shoot_cooldown = max(_shoot_cooldown - delta, 0)
	global_position = global_position.lerp(_target_position, lerp_speed * delta)

	look_at(get_global_mouse_position())

func update_position(player_position: Vector2, mouse_position: Vector2) -> void:
	var direction = (mouse_position - player_position).normalized()
	_target_position = player_position + (direction * radius)

func shoot() -> void:
	if _shoot_cooldown > 0:
		return

	_shoot_cooldown = 1.0 / fire_rate

	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	var muzzle_position = global_position + transform.x * muzzle_offset.x
	bullet.global_position = muzzle_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = global_rotation

	apply_recoil()


func apply_recoil() -> void:
	var recoil_direction = -transform.x * recoil_strength
	global_position += recoil_direction

	rotation += randf_range(-0.05, 0.05)
