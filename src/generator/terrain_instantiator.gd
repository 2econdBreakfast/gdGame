class_name TerrainInstantiator extends InstantiatorModule

var water_tiles = [Globals.TerrainTileType.WATER, Globals.TerrainTileType.DEEP_WATER]
func instantiate(generation_cache : Dictionary):
	var map_data : Array[Array] = generation_cache["map_data"]
	var tilemap : TileMap = generation_cache["terrain_tilemap"]
	
	tilemap.clear()
	for y in range(map_data.size()):
		for x in range(map_data[y].size()):
			var tile : MapTileData = map_data[y][x]
			if tile.terrain_type == Globals.TerrainTileType.BUILDING:
				continue
				
			var tilemap_layer = 0
			
			if tile.terrain_type in water_tiles:
				tilemap_layer = 1

			tilemap.set_cell(
				tilemap_layer,
				Vector2i(x, y),
				0,
				tile.terrain_type
			)
			

