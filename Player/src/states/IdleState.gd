class_name IdleState extends State

var animation_name = "idle"

func enter():
	super.enter()
	_player.play_animation("idle");

func process_input():
	if !_player.input_listener.dirInput.is_equal_approx(Vector2.ZERO):
		return state_machine.states.get("walk");
	else:
		return self
func interrupt():
	pass
