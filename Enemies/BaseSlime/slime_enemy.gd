extends EnemyBase
class_name SlimeEnemy

# --- Engine Functions ---
func _ready() -> void:
	# The 'super' keyword calls the _ready() function from the parent class (EnemyBase)
	super()

# --- Overridden Functions ---
func _on_health_depleted() -> void:
	super() 

func _enter_idle_state() -> void:
	super()

func _enter_wandering_state() -> void:
	super()

func _chase_player() -> void:
	super()
