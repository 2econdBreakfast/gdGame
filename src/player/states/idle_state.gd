class_name IdleState extends State

var animation_name = "idle"

func enter():
	super.enter()
	_player.play_animation("idle_" + _player.get_cardinal_direction_name());

func process_input():
	if Input.is_action_just_pressed("use_tool"):
		if _player.equipped_tool.can_use():
			return state_machine.states.get("use_tool")
	if Input.is_action_just_pressed("attack"):
		return state_machine.states.get("attack")
	if !_player.input_listener.dirInput.is_equal_approx(Vector2.ZERO):
		return state_machine.states.get("walk");
	else:
		return self
func interrupt():
	pass
