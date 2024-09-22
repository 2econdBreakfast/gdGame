class_name BuildingInstantiator extends InstantiatorModule


@export var building_container : Node2D

func instantiate(generation_cache : Dictionary):
	var cabin_scene : PackedScene = generation_cache.get("cabin_scene")
	var cabin_position = generation_cache.get("cabin_position")
	
	
	if !building_container:
		print("BuildingInstantiator: building_container (export var) not set.")
		return
	
	if !cabin_scene:
		print("BuildingInstantiator: couldn't find cabin_scene in cache")
		return
	
	if !cabin_scene:
		print("BuildingInstantiator: couldn't find cabin_position in cache")
		return
	
	var cabin : Node2D = cabin_scene.instantiate()
	
	cabin.global_position = cabin_position
	building_container.add_child(cabin)
