class_name IdleState extends State

var animation_name = "idle"

func enter():
	super.enter()
	_player.play_animation("idle");

func process_input():
	print("idle")
	if Input.is_action_just_pressed("attack"):
		if _player.equipped_tool.can_use(_player):
			print("using tool")
			_player.equipped_tool.use(_player)
		return state_machine.states.get("attack")
	if !_player.input_listener.dirInput.is_equal_approx(Vector2.ZERO):
		return state_machine.states.get("walk");
	else:
		return self
func interrupt():
	pass
