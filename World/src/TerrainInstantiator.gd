class_name TerrainInstantiator extends InstantiatorModule

func instantiate(generation_cache : Dictionary):
	var terrain : Array[Array] = generation_cache["terrain_map"]
	var tilemap : TileMap = generation_cache["terrain_tilemap"]
	
	tilemap.clear()
	for y in range(terrain.size()):
		var row = terrain[y]
		for x in range(row.size()):
			tilemap.set_cell(
				0,
				Vector2i(x, y),
				0,
				row[x]
			)
			

