extends Node2D

@export var radius: float = 10.0
@export var lerp_speed: float = 5.0

var _target_position: Vector2 = Vector2.ZERO

func _ready():
	# pulsing effect
	var tween = create_tween().set_loops()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(_target_position, lerp_speed * delta)
	look_at(get_global_mouse_position())

func update_position(player_position: Vector2, mouse_position: Vector2) -> void:
	var direction = (mouse_position - player_position).normalized()
	_target_position = player_position + (direction * radius)
