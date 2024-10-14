class_name UseToolState extends State

func enter():
	if not _player.equipped_tool.active:
		_player.equipped_tool.active = true

func process_input() -> State:
	return state_machine.states.get("idle")
