extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar

func update_bar(current_value: float, max_value: float) -> void:
	progress_bar.max_value = max_value
	progress_bar.value = current_value
	# Only show the health bar if the enemy is not at full health
	self.visible = (current_value < max_value)
