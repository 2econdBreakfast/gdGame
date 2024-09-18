extends Node

var grabbed_item_display : ItemDisplay

func _ready():
	var inv_root = get_parent()
	if !inv_root.is_node_ready():
		await inv_root.ready
		
	for slot : InventorySlot in inv_root.slots:
		slot.clicked.connect(on_slot_clicked)
		
func on_slot_clicked(slot : InventorySlot):
	var item_display : ItemDisplay = slot.get_node("ItemDisplay")
	grabbed_item_display = item_display
	item_display.grabbed = true



