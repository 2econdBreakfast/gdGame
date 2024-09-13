class_name RainfallGenerator extends GeneratorModule
@export var n : FastNoiseLite
func generate(generation_cache : Dictionary):
	var map_data = generation_cache.get("map_data")
	var width = generation_cache.get("width")
	var height = generation_cache.get("height")
	

	n.seed = randi()
	for y in range(height):
		for x in range(width):
			var tile_data = map_data[y][x] as MapTileData
			var v = n.get_noise_2d(y, x) * -1.0
			tile_data.rainfall = v

