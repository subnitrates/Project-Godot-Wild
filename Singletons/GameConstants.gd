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
const ENEMY_DEFAULT_MAX_HEALTH: int = 5
const ENEMY_DEFAULT_WANDER_SPEED: int = 30
const ENEMY_DEFAULT_CHASE_SPEED: int = 60
const ENEMY_DEFAULT_WANDER_DISTANCE: float = 50.0
const ENEMY_DEFAULT_MIN_IDLE_TIME: float = 0.8
const ENEMY_DEFAULT_MAX_IDLE_TIME: float = 2.0
const ENEMY_DEFAULT_XP_REWARD: int = 25

# --- Collectible Defaults --- #
const COIN_DEFAULT_VALUE: int = 1
