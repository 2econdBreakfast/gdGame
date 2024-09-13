class_name TerrainInstantiator extends InstantiatorModule

func instantiate(generation_cache : Dictionary):
	var map_data : Array[Array] = generation_cache["map_data"]
	var tilemap : TileMap = generation_cache["terrain_tilemap"]
	
	tilemap.clear()
	for y in range(map_data.size()):
		for x in range(map_data[y].size()):
			if map_data[y][x].biome == Globals.Biome.OCEAN:
				tilemap.set_cell(
					0,
					Vector2i(x, y),
					0,
					map_data[y][x].terrain_type
				)
			else:
				tilemap.set_cell(
					1,
					Vector2i(x, y),
					0,
					map_data[y][x].terrain_type
				)
			

