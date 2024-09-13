class_name TerrainGenerator extends GeneratorModule

static var THREAD_DICTIONARY : Dictionary = {}

static var ALL_THREADS_FINISHED : bool


func generate(generation_cache : Dictionary):
	var height = generation_cache.get("height")
	var width = generation_cache.get("width")
	var map_data : Array[Array] = generation_cache.get("map_data")
	var max_threads : int = generation_cache.get("max_threads")
	var map_rows_per_thread = height / max_threads;
	# ensure we get all remaining rows in final thread in case height \ max_threads gives remainder
	var last_thread_rows = map_rows_per_thread + height % max_threads
	var start_row = 0
	var end_row = 0
	var threads : Array[Thread]
	
	for i in range(max_threads):
		var thread = Thread.new()
		if i == max_threads - 1:
			end_row = min(start_row + map_rows_per_thread, height)
		else:
			end_row = start_row + last_thread_rows
		
		var map_data_slice = map_data.slice(start_row, end_row, 1, false)
		
		threads.append(thread)
		thread.start(func() : 
			determine_tiletype_threaded(map_data_slice)
			)
		
		start_row = end_row
		
	for thread in threads:
		thread.wait_to_finish()


func determine_tiletype_threaded(map_data_slice : Array[Array]):
	for y in range(map_data_slice.size()):
		for x in range(map_data_slice[y].size()):
			var tile_data = map_data_slice[y][x] as MapTileData
			
			if tile_data.height < GeneratorSettings.SHALLOW_WATER_MAX_HEIGHT:
				tile_data.terrain_type = Globals.TileCoords.WATER
			else:
				match(tile_data.biome):
					Globals.Biome.BEACH:
						tile_data.terrain_type = Globals.TileCoords.SAND
					Globals.Biome.PLAINS:
						tile_data.terrain_type = Globals.TileCoords.GRASS
					Globals.Biome.FOREST:
						tile_data.terrain_type = Globals.TileCoords.FOREST_GRASS
					_: return 0
