extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var coin_value: int = GameConstants.COIN_DEFAULT_VALUE

func _ready():
	animated_sprite_2d.play("default") 
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		collect_coin(body)

func collect_coin(collector: Node2D):
	var player_stats: PlayerStats = collector.find_child("PlayerStats")
	if player_stats:
		player_stats.add_coins(coin_value)
		print("PlayerStats coins are: ", player_stats.coins)
		queue_free() 
	else:
		print("Warning: PlayerStats not found on player. Coin not collected.")
