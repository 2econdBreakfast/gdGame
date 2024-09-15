@tool

class_name InventorySlot extends Control

var is_empty : bool :
	get: return itemData == null || count == 0


@export var itemData : ItemData:
	set(v):
		_itemData = v
		$ItemDisplay.texture = _itemData.spriteTexture if _itemData else null
	get:
		return _itemData

var count : int :
	set(v):
		$ItemDisplay/ItemCount.text = var_to_str(v)
		_count = v
	get: 
		return _count

var _count : int
var _itemData : ItemData

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
