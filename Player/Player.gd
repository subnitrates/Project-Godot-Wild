class_name Player
extends CharacterBody2D

var current_state: PlayerState

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hover_gun = $HoverGun

func _ready() -> void:
	current_state = PlayerIdleState.new()
	current_state.player = self
	current_state.enter() 

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	hover_gun.update_position(global_position, get_global_mouse_position())

func change_state(new_state_instance: PlayerState):
	if current_state:
		current_state.exit()
	
	current_state = new_state_instance
	current_state.player = self
