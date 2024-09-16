class_name Inventory extends Node



@export var money : int = 0
@onready var main_inv_slots : Control = $MainInventory/Panel/MarginContainer/VSplitContainer/CenterContainer/InventorySlots
@onready var quick_bar_slots : Control = $QuickBar/Panel/CenterContainer/InventorySlots
var slots : Array[InventorySlot]
const max_stack : int = 32
var _focused_slot : InventorySlot
func _ready():
	$QuickBar.visible = false
	$MainInventory.visible = false
	recache_slots()

func _process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if $MainInventory.visible:
			close_main()
		else:
			open_main()
		
func open_main():
	$AnimationPlayer.play("main_inv_fade_in")
	slots[0].grab_focus()
	
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
	var to_check = main_inv_slots.get_children()
	to_check.append_array(quick_bar_slots.get_children())
	for node in to_check:
		if node is InventorySlot:
			slots.append(node)
	return slots


func recache_slots():
	get_all_slots()
	for slot : InventorySlot in slots:
		# check if slot is already connected to the connect slot function
		# comparison number is 2 because signal is already connected internally
		# see InventorySlot._on_focus_entered()
		if slot.focus_entered.get_connections().size() < 2:
			slot.focus_entered.connect(func connect_slot(): self._on_slot_focus_entered(slot))
	

func _on_slot_focus_entered(focused_slot : InventorySlot):
	self._focused_slot = focused_slot
	print(_focused_slot.name)
