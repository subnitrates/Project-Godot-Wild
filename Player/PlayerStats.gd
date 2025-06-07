extends Node
class_name PlayerStats

signal health_changed(old_value, new_value)
signal stamina_changed(old_value, new_value)
signal coins_changed(old_value, new_value)
signal experience_changed(old_value, new_value, max_value)
signal level_changed(old_value, new_value)
signal player_died

@export var max_health: int = GameConstants.PLAYER_DEFAULT_MAX_HEALTH
@export var max_stamina: int = GameConstants.PLAYER_DEFAULT_MAX_STAMINA
@export var starting_coins: int = GameConstants.PLAYER_DEFAULT_STARTING_COINS
@export var stamina_regen_rate: float = GameConstants.PLAYER_DEFAULT_STAMINA_REGEN_RATE
@export var stamina_regen_delay: float = GameConstants.PLAYER_DEFAULT_STAMINA_REGEN_DELAY
@export var level: int = GameConstants.PLAYER_DEFAULT_LEVEL
@export var experience_to_next_level: int = GameConstants.PLAYER_DEFAULT_EXPERIENCE_TO_NEXT_LEVEL

var stamina_regen_timer := 0.0
var _stamina_regen_accumulator: float = 0.0

var health: int:
	set(value):
		var old_health = health
		health = clamp(value, 0, max_health)
		health_changed.emit(old_health, health)
		if health <= 0:
			player_died.emit()

var stamina: int:
	set(value):
		var old_stamina = stamina
		stamina = clamp(value, 0, max_stamina)
		stamina_changed.emit(old_stamina, stamina)

var coins: int:
	set(value):
		var old_coins = coins
		coins = max(0, value)
		coins_changed.emit(old_coins, coins)

var experience: int:
	set(value):
		var old_exp = experience
		experience = value
		if old_exp != experience: experience_changed.emit(old_exp, experience, experience_to_next_level)

func _ready():
	health = max_health
	stamina = max_stamina
	coins = starting_coins
	experience = 0

func _process(delta: float):
	if stamina_regen_timer > 0:
		stamina_regen_timer -= delta
	elif stamina < max_stamina:
		_stamina_regen_accumulator += stamina_regen_rate * delta
		
		if _stamina_regen_accumulator >= 1.0:
			var regen_amount = floor(_stamina_regen_accumulator)
			stamina += regen_amount
			_stamina_regen_accumulator -= regen_amount

func add_experience(amount: int) -> void:
	experience += amount
	while experience >= experience_to_next_level:
		var old_level = level
		level += 1
		experience -= experience_to_next_level
		experience_to_next_level = int(experience_to_next_level * 1.5)
		level_changed.emit(old_level, level)
		experience_changed.emit(0, experience, experience_to_next_level)

func use_stamina(amount: int) -> bool:
	if stamina >= amount:
		stamina -= amount
		stamina_regen_timer = stamina_regen_delay
		_stamina_regen_accumulator = 0 
		return true
	return false

func take_damage(amount: int):
	health -= amount

func heal(amount: int):
	health += amount

func restore_stamina(amount: int):
	stamina += amount

func add_coins(amount: int):
	coins += amount

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		return true
	return false
