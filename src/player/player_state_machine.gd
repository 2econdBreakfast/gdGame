class_name PlayerStateMachine extends Node

var current_state

@onready var states : Dictionary = {
	"idle" : get_node("IdleState"),
	"walk" : get_node("WalkState"),
	"run"  : get_node("RunState"),
	"attack":get_node("AttackState"),
	"use_tool": get_node("UseToolState"),
	"use_hoe": get_node("UseHoeState")
}
signal state_exited(state: State)
signal state_entered(state: State)

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_states()
	self._set_state(states["idle"])

func initialize_states():
	var player = get_parent()
	for state:State in states.values():
		state.init_state(player)

@warning_ignore("unused_parameter")
func process_state(delta):
	var new_state = current_state.process_input();
	if new_state != current_state:
		_set_state(new_state)

func process_state_physics(delta):
	if current_state:
		current_state.process_physics(delta)

func _set_state(new_state : State):
	if (current_state):
		current_state.exit()
		state_exited.emit(current_state)
	current_state = new_state
	current_state.enter()
	state_entered.emit(current_state)
