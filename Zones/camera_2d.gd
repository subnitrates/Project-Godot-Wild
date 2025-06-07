extends Camera2D

@export var target_node_path: NodePath 
@export var follow_speed: float = 5.0 

var target: Player

func _ready():
	if target_node_path:
		target = get_node(target_node_path)
	if not target:
		print("Warning: Camera target not found.")

func _process(delta):
	if target:
		var desired_position = target.global_position + offset
		# Smoothly move the camera towards the desired position
		global_position = global_position.lerp(desired_position, follow_speed * delta)
