class_name Inventory extends Node



@export var money : int = 0
@onready var main_inv_slots : Control = $MainInventory/Panel/MarginContainer/VSplitContainer/CenterContainer/InventorySlots
@onready var quick_bar_slots : Control = $QuickBar/Panel/InventorySlots
var slots : Array[InventorySlot]
const max_stack : int = 32

func _ready():
	$QuickBar.visible = false
	$MainInventory.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if $MainInventory.visible:
			close_main()
		else:
			open_main()
		
func open_main():
	$AnimationPlayer.play("main_inv_fade_in")
	
func close_main():
	$AnimationPlayer.play("main_inv_fade_out")

	
func open_quickbar():
	$AnimationPlayer.play("quickbar_fade_out")
	
func close_quickbar():
	$AnimationPlayer.play("quickbar_fade_out")
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
	var to_check = quick_bar_slots.get_children()
	to_check.append_array(main_inv_slots.get_children())
	for node in to_check:
		if node is InventorySlot:
			slots.append(node)
	return slots
