class_name HeightmapGenerator extends GeneratorModule

@export var n1 = FastNoiseLite.new()
enum NOISE_SUPERPOSITION_MODE {
	NORMAL,
	DARKEN_ONLY,
	LIGHTEN_ONLY,
	MULTIPLY,
	ADD,
	SUBTRACT,
	DIVIDE,
	DIFFERENCE
}

var noise_superposition_functions : Dictionary = {
	NOISE_SUPERPOSITION_MODE.NORMAL :			func(a, b): return (a + b) / 2,
	NOISE_SUPERPOSITION_MODE.DARKEN_ONLY : 		func(a, b): return (a + b) / 2 if b < a else a, 
	NOISE_SUPERPOSITION_MODE.LIGHTEN_ONLY : 	func(a, b): return (a + b) / 2 if b > a else a,
	NOISE_SUPERPOSITION_MODE.MULTIPLY : 		func(a, b): return a * b,
	NOISE_SUPERPOSITION_MODE.DIVIDE : 			func(a, b): return a / b,
	NOISE_SUPERPOSITION_MODE.ADD : 				func(a,b): return a + b,
	NOISE_SUPERPOSITION_MODE.SUBTRACT : 		func(a, b): return a - b,
	NOISE_SUPERPOSITION_MODE.DIFFERENCE : 		func (a, b): return abs(a - b),
}
@export var noise_superposition_mode : NOISE_SUPERPOSITION_MODE

@export var n1_weight : float = 0.66
func generate(generation_cache : Dictionary):
	var width : int = generation_cache.get("width")
	var height : int = generation_cache.get("height")
	var n2_weight = 1.0 - n1_weight
	randomize()
	n1.seed = randi()

	var n1_image = n1.get_image(width, height,false,false,true)
	
	var heightmap : Array[Array] = []
	for y in range(height):
		heightmap.append(Array())
		for x in range(width):
			
			var v = n1_image.get_pixel(x,y).v
			
			#v = clamp(v, 0, 1)
			heightmap[y].append(v)
	
	generation_cache["heightmap"] = heightmap
