class_name HeightmapGenerator extends GeneratorModule

@export var n1 = FastNoiseLite.new()

func generate():
	var width : int = WORLD_DATA.cache.get("width")
	var height : int = WORLD_DATA.cache.get("height")
	var map_data : Array[Array] = WORLD_DATA.cache.get("map_data")
	
	randomize()
	n1.seed = randi()

	var n1_image = n1.get_image(width, height,false,false,true)
	

	for y in range(height):
		for x in range(width):
			
			var tile = map_data[y][x] as MapTileData
			var v = n1_image.get_pixel(x,y).v - (y / height)
			
			#v = clamp(v, 0, 1)
			tile.height = v
