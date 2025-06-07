extends Control
class_name GameUI

@onready var level_progress_bar: ProgressBar = %LevelProgressBar
@onready var level_label: Label = %LevelLabel
@onready var coin_label: Label = %CoinLabel

var player_stats: PlayerStats

func _ready() -> void:
	await get_tree().process_frame
	
	var player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(player):
		print("GameUI Error: Player node not found. UI will not update.")
		return
		
	player_stats = player.find_child("PlayerStats")
	if not is_instance_valid(player_stats):
		print("GameUI Error: PlayerStats node not found. UI will not update.")
		return
	
	player_stats.coins_changed.connect(_on_coins_changed)
	player_stats.experience_changed.connect(_on_experience_changed)
	player_stats.level_changed.connect(_on_level_changed)
	_on_coins_changed(0, player_stats.coins)
	
func _on_coins_changed(_old_value: int, new_value: int) -> void:
	coin_label.text = "Coins: " + str(new_value)

func _on_level_changed(_old_value: int, new_value: int) -> void:
	level_label.text = "Level: " + str(new_value)

func _on_experience_changed(_old_value: int, new_value: int, max_value: int) -> void:
	level_progress_bar.max_value = max_value
	level_progress_bar.value = new_value
