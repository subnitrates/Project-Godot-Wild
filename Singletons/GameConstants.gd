extends Node
## GLOBAL CONSTANTS

# --- Player ---
# Movement
const PLAYER_BASE_SPEED: float = 100.0

# Stats
const PLAYER_DEFAULT_MAX_HEALTH: int = 100
const PLAYER_DEFAULT_MAX_STAMINA: int = 100
const PLAYER_DEFAULT_STARTING_COINS: int = 0
const PLAYER_DEFAULT_STAMINA_REGEN_RATE: float = 40.0
const PLAYER_DEFAULT_STAMINA_REGEN_DELAY: float = 1.0
const PLAYER_DEFAULT_LEVEL: int = 1
const PLAYER_DEFAULT_EXPERIENCE_TO_NEXT_LEVEL: int = 100

# Dash System
const DASH_DURATION: float = 0.15
const DASH_COOLDOWN: float = 0.3
const DASH_SPEED_MULTIPLIER: float = 2.5
const DASH_COST: int = 35
const DASH_COLOR: Color = Color(0.7, 0.7, 1.0, 0.8)
const DASH_DEFAULT_DIRECTION: Vector2 = Vector2.RIGHT

# Gun Constants
const GUN_RADIUS: float = 10.0
const GUN_LERP_SPEED: float = 5.0
const GUN_FIRE_RATE: float = 5.0
const GUN_RECOIL_STRENGTH: float = 5.0
const GUN_MUZZLE_OFFSET: Vector2 = Vector2(7, 0)
const GUN_PULSE_SCALE: Vector2 = Vector2(1.1, 1.1)
const GUN_PULSE_DURATION: float = 0.5

# Bullet Constants
const BULLET_DEFAULT_SPEED: float = 800.0
const BULLET_DEFAULT_DAMAGE: int = 10
const BULLET_DEFAULT_LIFETIME: float = 2.0

# --- Enemy Defaults --- #
# These can be used as default values for enemies,
const EnemyStats: Dictionary = {
	"DEFAULT": {
		"max_health": 15,
		"wander_speed": 10,
		"chase_speed": 10,
		"wander_distance": 10.0,
		"min_idle_time": 10.0,
		"max_idle_time": 20.0,
		"xp_reward": 100
	},
	"SLIME": {
		"max_health": 50,
		"wander_speed": 20,
		"chase_speed": 40,
		"wander_distance": 30.0,
		"min_idle_time": 2.0,
		"max_idle_time": 5.0,
		"xp_reward": 15
	},
	"GIGA_SLIME": {
		"max_health": 200,
		"wander_speed": 30,
		"chase_speed": 30,
		"wander_distance": 100.0,
		"min_idle_time": 0.5,
		"max_idle_time": 1.5,
		"xp_reward": 30
	}
}

# Spawner 
const SPAWNER_DEFAULT_MAX_HEALTH: int = 100
const SPAWNER_DEFAULT_SPAWN_COUNT: int = 3
const SPAWNER_DEFAULT_MAX_ENEMIES: int = 10
const SPAWNER_DEFAULT_SPAWN_RADIUS: float = 100.0
const SPAWNER_DEFAULT_SPAWN_INTERVAL: float = 5.0

# --- Collectible Defaults --- #
const COIN_DEFAULT_VALUE: int = 1
