class_name RiverGenerator extends GeneratorModule

@export var num_rivers : int = 1
var perlin_worms : Array[PerlinWorm] = []


func generate(generation_cache : Dictionary):
	var width = generation_cache.get("width")
	var height = generation_cache.get("height")
	var heightmap = generation_cache.get("heightmap")
	var terrain_map = generation_cache.get("terrain_map")
	
	for i in range(num_rivers):
		var worm = PerlinWorm.new()
		perlin_worms.append(worm)
		var start = Vector2i.UP
		#worm.initialize_path()
	for worm : PerlinWorm in perlin_worms:
		#worm.initialize_path()
