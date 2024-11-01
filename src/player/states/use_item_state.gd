class_name UseItemState extends State

func enter():
	var item = _player.inventory.active_quick_slot.itemData
	if item and item is ConsumableItemData and not item.active:
		_player.activate_item()

func process_input() -> State:
	return state_machine.states.get("idle")
