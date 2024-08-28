class_name InitializeIdleTimer extends ActionLeaf

@export var max_ticks : int = 1000
@export var min_ticks : int = 50
var cur_ticks = 0

@warning_ignore("unused_parameter")
func tick(actor, blackboard: Blackboard):
	blackboard.set_value("tick_limit", randi_range(min_ticks, max_ticks))
	
	if actor.debug_behavior_tree:
		print(blackboard.get_value("tick_limit"))
	
	return SUCCESS
