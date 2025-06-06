class_name Player
extends CharacterBody2D

var current_state: PlayerState

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hover_gun = $HoverGun

var is_shooting: bool = false


func _ready() -> void:
	current_state = PlayerIdleState.new()
	current_state.player = self
	current_state.enter() 

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	hover_gun.update_position(global_position, get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		hover_gun.shoot()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		is_shooting = true
	elif event.is_action_released("shoot"):
		is_shooting = false

func change_state(new_state_instance: PlayerState):
	if current_state:
		current_state.exit()
	
	current_state = new_state_instance
	current_state.player = self
