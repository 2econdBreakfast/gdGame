class_name InventorySlot extends Control


var is_empty : bool :
	get: return itemData == null || count == 0


@export var itemData : ItemData:
	set(v):
		$ItemDisplay.item_data = v
	get:
		return $ItemDisplay.item_data if $ItemDisplay else null
		
var count : int :
	set(v):
		$ItemDisplay.count = v
	get: 
		return $ItemDisplay.count

func add(new_item : ItemData, amount : int):
	var remainder = 0
	
	if amount <= 0: return amount
	
	elif (itemData and itemData.id == new_item.id):
		if count + amount > Inventory.max_stack:
			remainder = amount - (Inventory.max_stack - count)
			count = Inventory.max_stack
		else:
			count += amount
	else:
		itemData = new_item
		count = amount
		
	return remainder

func remove(amount : int):
	if amount >= count:
		itemData = null
		count = 0
	else:
		count -= amount

func _on_focus_entered():
	self.add_theme_stylebox_override("panel", \
		self.get_theme_stylebox("focus", "InventorySlot"))


func _on_focus_exited():
	self.remove_theme_stylebox_override("panel")
