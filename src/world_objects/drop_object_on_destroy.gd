class_name DropObjectOnDestroy extends Node

@export var item_prefab : PackedScene

func _on_tree_destroyed():
	if item_prefab:
		var item_pos = get_parent().global_position + Vector2(randi_range(-5, 5), randi_range(-5, 5))
		ItemManager.instantiate_item(item_prefab, item_pos)

