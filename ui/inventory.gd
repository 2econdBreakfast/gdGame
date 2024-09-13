class_name Inventory extends Node



@export var money : int = 0
@onready var slotContainer : Control = $AspectRatioContainer/MarginContainer2/InventorySlots
var slots : Array[InventorySlot]
const max_stack : int = 32

func add(item : Item, amount : int):
	var itemData : ItemData = item.itemData
	
	
	var slot : InventorySlot = find_slot_for_item(itemData)
	
	if !slot:
		print("no free slots for ", itemData.item_name)
		return
		
	else:
		while (amount):
			amount = slot.add(itemData, amount)
			slot = find_slot_for_item(itemData)
	
	if !slots || slots.size() == 0:
		return

func find_slot_for_item(new_itemData : ItemData) -> InventorySlot:
	var slots : Array[InventorySlot] = get_all_slots()
	if !slots:
		print("couldn't find an empty slot for ", new_itemData.item_name)
		return
		
	var first_empty_slot : InventorySlot
	for slot : InventorySlot in slots:
		if slot.is_empty and !first_empty_slot:
			first_empty_slot = slot
		if slot.itemData == new_itemData:
			if slot.count < max_stack:
				return slot
	
	return first_empty_slot
	
func get_all_slots() -> Array[InventorySlot]:
	var slots : Array[InventorySlot] = []
	for slot : InventorySlot in slotContainer.get_children():
		if slot is InventorySlot:
			slots.append(slot)
	return slots
