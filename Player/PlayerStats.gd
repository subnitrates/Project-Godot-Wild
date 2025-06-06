extends Node
class_name PlayerStats

signal health_changed(old_value, new_value)
signal stamina_changed(old_value, new_value)
signal coins_changed(old_value, new_value)
signal player_died

@export var max_health := 100
@export var max_stamina := 100
@export var starting_coins := 0
@export var stamina_regen_rate := 40.0 
@export var stamina_regen_delay := 1.0 

var stamina_regen_timer := 0.0

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

var _stamina_regen_accumulator: float = 0.0

func _ready():
	health = max_health
	stamina = max_stamina
	coins = starting_coins

func _process(delta: float):
	if stamina_regen_timer > 0:
		stamina_regen_timer -= delta
	elif stamina < max_stamina:
		_stamina_regen_accumulator += stamina_regen_rate * delta
		
		if _stamina_regen_accumulator >= 1.0:
			var regen_amount = floor(_stamina_regen_accumulator)
			stamina += regen_amount
			_stamina_regen_accumulator -= regen_amount


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
