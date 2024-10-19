class_name UseToolState extends State

func enter():
	if _player.equipped_tool and not _player.equipped_tool.active:
		_player.activate_tool()

func process_input() -> State:
	return state_machine.states.get("idle")
