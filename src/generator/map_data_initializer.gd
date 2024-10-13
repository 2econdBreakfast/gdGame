class_name MapDataInitializer extends GeneratorModule


func generate():
	var map_data : Array[Array] = []
	var width = WORLD_DATA.cache["width"]
	var height = WORLD_DATA.cache["height"]

	map_data.resize(height)
	for row in map_data:
		for i in range(width):
			row.append(MapTileData.new())
			
	WORLD_DATA.cache["map_data"] = map_data

