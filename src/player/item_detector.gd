class_name ItemDetector extends Node2D

var inventory : Inventory

func _on_collection_radius_area_entered(area):
	print("item detected: ", area.name)
	var area_owner : Item = area.get_parent()
	if (area_owner):
		if inventory:
			inventory.add(area_owner, 1)
			area_owner.call_deferred("queue_free")
