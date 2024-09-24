class_name Inventory extends Control

@export var money : int = 0
@onready var main_inv_slots : Control = $MainInventory/Panel/MarginContainer/VSplitContainer/CenterContainer/InventorySlots
@onready var quick_bar_slots : Control = $QuickBar/Panel/CenterContainer/InventorySlots
var slots : Array[InventorySlot]
const max_stack : int = 32
var focused_slot : InventorySlot
var grabbed_item : ItemDisplay

var quickbar_actions : Array[String] = [
	"quick_bar_1",
	"quick_bar_2",
	"quick_bar_3",
	"quick_bar_4",
	"quick_bar_5",
	"quick_bar_6"
]

var displaying : bool
func _ready():
	$QuickBar.visible = false
	$MainInventory.visible = false
	recache_slots()
	$QuickbarDisplayTimer.timeout.connect(close_quickbar)

func _input(event):
	if Input.is_action_just_pressed("toggle_inventory"):
		if $MainInventory.visible:
			displaying = false
			close_main()
		else:
			displaying = true
			open_main()
	else:
		for action in quickbar_actions:
			if Input.is_action_just_pressed(action):
				open_quickbar()
				break

		
func open_main():
	print("opening inv")
	if $QuickBar.visible:
		close_quickbar()
		await $AnimationPlayer.animation_finished
	$QuickBar.visible = true
	$MainInventory.visible = true
	$AnimationPlayer.play("main_inv_fade_in")
	
func close_main():
	$AnimationPlayer.play("main_inv_fade_out")
	await $AnimationPlayer.animation_finished
	$QuickBar.visible = false
	$MainInventory.visible = false
	
func open_quickbar():
	if $MainInventory.visible:
		return
		print("can't open quickbar, main inv still open")
	if !$QuickBar.visible:
		$QuickBar.visible = true
		$AnimationPlayer.play("quickbar_fade_in")
		await $AnimationPlayer.animation_finished
	$QuickbarDisplayTimer.start()
	
	
func close_quickbar():
	if $MainInventory.visible:
		return
	if $QuickBar.visible:
		$AnimationPlayer.play("quickbar_fade_out")
		await $AnimationPlayer.animation_finished
		$QuickBar.visible = false

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

# Prevent the control from focusing when clicked but allow programmatic focus
func _can_focus() -> bool:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return false
	return true  # Allow focus by other means (keyboard, programmatically)
func recache_slots():
	get_all_slots()
