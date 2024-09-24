class_name CursorManager extends Control

var grabbed_item: ItemDisplay
var focused_slot: InventorySlot
var inv_root : Inventory

func _ready():
	inv_root = get_parent()

func _input(event):
	if inv_root.displaying:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
			call_deferred("_move_focus_to_slot")
			_move_focus_to_slot()

		if Input.is_action_just_pressed("ui_select"):
			grab_or_swap_item()

func _move_focus_to_slot():
	# Move focus to the next slot if there is none
	if not get_viewport().gui_get_focus_owner() is InventorySlot:
		var slots = _get_all_slots()
		if slots.size() > 0:
			slots[0].grab_focus()
			self.global_position = slots[0].global_position
	
	else:
		self.global_position = get_viewport().gui_get_focus_owner().global_position
		
	focused_slot = get_viewport().gui_get_focus_owner()
	
	update_grabbed_item_position()

func grab_or_swap_item():
	if grabbed_item:
		# Get the parent of the grabbed item
		var grabbed_item_parent = grabbed_item.get_parent()
		if grabbed_item_parent:
			grabbed_item_parent.remove_child(grabbed_item)

		# Get the item in the currently focused slot
		if focused_slot.get_child_count() > 0:
			var other_item = focused_slot.get_child(0)
			if other_item:
				# Swap items between slots
				focused_slot.remove_child(other_item)
				grabbed_item_parent.add_child(other_item)
				focused_slot.add_child(grabbed_item)
		else:
			# If the focused slot is empty, just add the grabbed item to it
			focused_slot.add_child(grabbed_item)

		# Reset the grabbed item
		grabbed_item.position = Vector2(0, 0)
		grabbed_item.grabbed = false
		grabbed_item = null
	else:
		# If no item is grabbed, grab the item from the focused slot
		if focused_slot.get_child_count() > 0:
			var selected_item: ItemDisplay = focused_slot.get_child(0)
			if selected_item.item_data:
				# Mark the item as grabbed
				selected_item.grabbed = true
				grabbed_item = selected_item

func update_grabbed_item_position():
	if grabbed_item:
		grabbed_item.global_position = global_position

func update_cursor_position():
	if focused_slot:
		position = focused_slot.get_global_position()
		show()
	else:
		hide()

func clear_cursor():
	grabbed_item = null
	focused_slot = null

func _process(delta):
	# Update the cursor position continuously based on focused slot
	if focused_slot:
		update_cursor_position()

func _on_focus_entered(slot: InventorySlot):
	focused_slot = slot
	update_cursor_position()

func _on_focus_exited(slot: InventorySlot):
	if focused_slot == slot:
		clear_cursor()

func _get_all_slots() -> Array:
	# Get all slots from the Inventory UI, modify this if needed
	return inv_root.slots
