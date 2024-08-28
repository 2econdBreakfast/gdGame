class_name RainfallGenerator extends GeneratorModule
@export var n1 : FastNoiseLite
func generate(generation_cache : Dictionary):
	var width = generation_cache.get("width")
	var height = generation_cache.get("height")
	

	n1.seed = randi()

	
	var rainfall_map : Array[Array]
	for y in range(height):
		rainfall_map.append(Array())
		for x in range(width):
			var noise_val = n1.get_noise_2d(y, x) * -1.0
			rainfall_map[y].append(noise_val)
	
	generation_cache["rainfall_map"] = rainfall_map
