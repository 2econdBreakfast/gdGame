class_name State extends Node

var _player : Player
@onready var state_machine : PlayerStateMachine = get_parent()

func init_state(player : Player):
	self._player = player
	
func enter():
	pass
	
func exit():
	pass
	
func process_input() -> State:
	return self;
@warning_ignore("unused_parameter")
func process_physics(delta):
	pass
