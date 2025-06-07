extends Area2D

@export var speed: float = GameConstants.BULLET_DEFAULT_SPEED
@export var damage: int = GameConstants.BULLET_DEFAULT_DAMAGE
@export var lifetime: float = GameConstants.BULLET_DEFAULT_LIFETIME
@onready var destroy_timer: Timer = $DestroyTimer

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	$DestroyTimer.wait_time = lifetime
	$DestroyTimer.start()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free() 

func _on_destroy_timer_timeout():
	queue_free() 
