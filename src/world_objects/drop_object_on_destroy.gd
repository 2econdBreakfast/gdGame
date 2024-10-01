class_name DropObjectOnDestroy extends Node

@export var item_prefab : PackedScene

func _ready():
	var parent = get_parent()
	if parent is DestructibleObject:
		if !parent.destroyed.is_connected(self._on_destroyed):
			parent.destroyed.connect(self._on_destroyed)
		else:
			print_debug(name, "DropObjectOnDestroy must be a child of a DestructibleObject node or other node with a 'destroyed' signal");
func _on_destroyed():
	if item_prefab:
		var item_pos = get_parent().global_position + Vector2(randi_range(-5, 5), randi_range(-5, 5))
		ItemManager.instantiate_item(item_prefab, item_pos)

