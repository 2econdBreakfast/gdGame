class_name TerrainInstantiator extends InstantiatorModule

func instantiate():
	var map_data : Array[Array] = WORLD_DATA.cache["map_data"]
	var tilemap : TileMap = WORLD_DATA.terrain_tilemap
	
	tilemap.clear()
	for y in range(map_data.size()):
		for x in range(map_data[y].size()):
			var tile : MapTileData = map_data[y][x]
			if tile.terrain_type == Globals.TerrainTileType.BUILDING:
				continue
				
			var tilemap_layer = 0
			
			if tile.biome == Globals.Biome.OCEAN:
				tilemap_layer = 1

			tilemap.set_cell(
				1,
				Vector2i(x, y),
				0,
				tile.terrain_type
			)
			

