class_name TerrainGenerator extends GeneratorModule

static var THREAD_DICTIONARY : Dictionary = {}

static var ALL_THREADS_FINISHED : bool


func generate(generation_cache : Dictionary):
	var terrain_map : Array[Array] = generation_cache["heightmap"].duplicate(true)
	var biome_map : Array[Array] = generation_cache["biome_map"]
	var max_threads : int = generation_cache.get("max_threads")
	var map_rows_per_thread = terrain_map.size() / max_threads;
	var last_thread_rows = map_rows_per_thread + terrain_map.size()  % max_threads
	var start_row = 0
	var end_row = 0
	var threads : Array[Thread]
	
	for i in range(max_threads):
		var thread = Thread.new()
		if i == max_threads - 1:
			end_row = min(start_row + map_rows_per_thread, terrain_map.size())
		else:
			end_row = start_row + last_thread_rows
		
		var terrain_map_slice = terrain_map.slice(start_row, end_row, 1, false)
		var biome_map_slice = biome_map.slice(start_row, end_row, 1, false)
		
		threads.append(thread)
		thread.start(func() : 
			height_to_tiletype_threaded(terrain_map_slice, biome_map_slice)
			)
		
		start_row = end_row
		
	for thread in threads:
		thread.wait_to_finish()
		
	generation_cache["terrain_map"] = terrain_map

func height_to_tiletype_threaded(heightmap_slice : Array[Array], biome_map_slice : Array[Array]):
	for y in range(heightmap_slice.size()):
		for x in range(heightmap_slice[y].size()):
			heightmap_slice[y][x] = determine_tiletype(heightmap_slice[y][x], biome_map_slice[y][x])

func determine_tiletype(height_value : float, biome : int):
	match(biome):
		Globals.Biome.WATER:
			if height_value < GeneratorSettings.DEEP_WATER_MAX_HEIGHT:
				return Globals.TileCoords.DEEP_WATER
			else:
				return Globals.TileCoords.WATER
		Globals.Biome.BEACH:
			return Globals.TileCoords.SAND
		Globals.Biome.PLAINS:
			return Globals.TileCoords.GRASS
		Globals.Biome.FOREST:
			return Globals.TileCoords.FOREST_GRASS
		_: return 0
		
