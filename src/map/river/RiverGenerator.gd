class_name RiverGenerator extends GeneratorModule

@export var num_rivers : int = 1
var perlin_worms : Array[PerlinWorm] = []


func generate():
	var width = WORLD_DATA.cache.get("width")
	var height = WORLD_DATA.cache.get("height")
	var heightmap = WORLD_DATA.cache.get("heightmap")
	var terrain_map = WORLD_DATA.cache.get("terrain_map")
	
	for i in range(num_rivers):
		var worm = PerlinWorm.new()
		perlin_worms.append(worm)
		var start = Vector2i.UP
		#worm.initialize_path()
	#for worm : PerlinWorm in perlin_worms:
		##worm.initialize_path()
