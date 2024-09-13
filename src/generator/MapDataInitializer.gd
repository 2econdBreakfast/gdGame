class_name MapDataInitializer extends GeneratorModule


func generate(generation_cache : Dictionary):
	var map_data : Array[Array] = []
	var width = generation_cache["width"]
	var height = generation_cache["height"]

	map_data.resize(height)
	for row in map_data:
		for i in range(width):
			row.append(MapTileData.new())
			
	generation_cache["map_data"] = map_data

