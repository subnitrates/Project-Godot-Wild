extends Area2D

@export var speed: float = GameConstants.BULLET_DEFAULT_SPEED
@export var damage: int = GameConstants.BULLET_DEFAULT_DAMAGE
@export var lifetime: float = GameConstants.BULLET_DEFAULT_LIFETIME

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
	else:
		pass
	queue_free()
