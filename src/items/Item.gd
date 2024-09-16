@tool
class_name Item extends Node2D

@export var item_sprite : Sprite2D

var unknown_item: 
	get: 
		return load("res://assets/unknown_item.tres")

@export var itemData : ItemData:
	set(v):
		_itemData = v
		if item_sprite:
			item_sprite.texture = _itemData.spriteTexture if _itemData else null
	get:
		return _itemData
# Backing field for itemData
var _itemData : ItemData

var id:
	get:
		return _itemData.id if _itemData else -1

var item_name:
	get:
		return _itemData.item_name if _itemData else "unknown_item"

var item_description:
	get:
		return _itemData.item_description if _itemData else "unknown item"

func _ready():
	$AnimationPlayer.play("ItemHover")
