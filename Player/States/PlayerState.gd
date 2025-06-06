class_name PlayerState
extends Node

var player: Player

func enter():
	pass

func exit():
	pass

func update(delta:float):
	pass

func handle_input(event: InputEvent):
	pass
	
func transition_to(new_state_instance: PlayerState):
	if player:
		player.change_state(new_state_instance)
	else:
		printerr("PlayerStates: Couldn't transition states")
