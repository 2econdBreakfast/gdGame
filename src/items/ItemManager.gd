class_name ItemManager extends Node2D

static var instance : ItemManager

# Called when the node enters the scene tree for the first time.
func _ready():
	if ItemManager.instance and ItemManager.instance != self:
		call_deferred("queue_free")
	else:
		instance = self

static func instantiate_item(item_prefab, item_position):
	if !instance:
		print("Tried to instantiate item, but no item manager instance exists.")
		return
	instance._instantiate_item_deferred(item_prefab, item_position)
	
func _instantiate_item_deferred(item_prefab, item_position):
	call_deferred("_instantiate_item", item_prefab, item_position)

func _instantiate_item(item_prefab, item_position):
	var item = item_prefab.instantiate()
	print("instantiating")
	item.global_position = item_position
	add_child(item)

