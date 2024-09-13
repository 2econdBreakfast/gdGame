class_name WaitForTimer extends ConditionLeaf

var cur_ticks : int
var tick_limit : int

@warning_ignore("unused_parameter")
func before_run(actor, blackboard : Blackboard):
	tick_limit = blackboard.get_value("tick_limit")

@warning_ignore("unused_parameter")
func tick(actor, blackboard: Blackboard):
	if(cur_ticks > tick_limit):
		return SUCCESS
	else:
		cur_ticks += 1
		return RUNNING

@warning_ignore("unused_parameter")
func after_run(actor, blackboard: Blackboard):
	blackboard.erase_value("tick_limit")
	cur_ticks = 0	
