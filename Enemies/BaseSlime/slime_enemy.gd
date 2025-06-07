extends EnemyBase
class_name SlimeEnemy


func _ready() -> void:
	self.enemy_type = "SLIME"
	super()

# --- Overridden Functions ---
func set_state(new_state: EnemyState) -> void:
	if current_state == new_state:
		return
		
	super.set_state(new_state)

	match new_state:
		EnemyState.IDLE:
			sprite.play("Idle")
		EnemyState.WANDERING:
			sprite.play("Idle")
		EnemyState.CHASING:
			sprite.play("Jump")

func _on_health_depleted() -> void:
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	self.hide()
	super._on_health_depleted()
