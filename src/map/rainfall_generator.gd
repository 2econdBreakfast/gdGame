class_name RainfallGenerator extends GeneratorModule
@export var n : FastNoiseLite
func generate():
	var map_data = WORLD_DATA.cache.get("map_data")
	var width = WORLD_DATA.cache.get("width")
	var height = WORLD_DATA.cache.get("height")
	

	n.seed = randi()
	for y in range(height):
		for x in range(width):
			var tile_data = map_data[y][x] as MapTileData
			var v = n.get_noise_2d(y, x) * -1.0
			tile_data.rainfall = v

