class_name Inventory extends Control

@export var money : int = 0
@onready var main_inv_slots : Control = $InventorySlots
var slots : Array[InventorySlot]
const max_stack : int = 32
var grabbed_item : ItemDisplay
const NORMAL_SLOT_STYLE : String = "InventorySlot"

var displaying : bool:
	get: return visible

func _ready():
	recache_slots()

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
	slots = []
	if main_inv_slots != null:
		var to_check = main_inv_slots.get_children()
		for node in to_check:
			if node is InventorySlot:
				slots.append(node)
	return slots

# Prevent the control from focusing when clicked but allow programmatic focus
func _can_focus() -> bool:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return false
	return true  # Allow focus by other means (keyboard, programmatically)
	
func recache_slots():
	get_all_slots()
