class_name PlantManager extends Node

var plants : Dictionary = {}


func add_plant(plant_type : Globals.PlantType, position : Vector2i):
	if not plants.has(position):
		plants[position] = PlantData.new(
			plant_type,
			0 # age
		)

func remove_plant_at(position : Vector2i):
	if plants.has(position):
		plants.erase(position)
		
func get_plant_at(position : Vector2i):
	if plants.has(position):
		return plants.get(position)
