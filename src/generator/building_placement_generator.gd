class_name BuildingPlacementGenerator extends GeneratorModule

@export var cabin_scene : PackedScene

var incompatible_terrain_types = [Globals.TerrainTileType.WATER, Globals.TerrainTileType.DEEP_WATER]

func generate(generation_cache : Dictionary):
	var map_width = generation_cache.get("width")
	var map_height = generation_cache.get("height")
	var map_data : Array[Array] = generation_cache.get("map_data")
	
	generation_cache["cabin_scene"] = cabin_scene
	var cabin = cabin_scene.instantiate()
	cabin = cabin as Building
	
	
	var tilemap : TileMap = generation_cache.get("terrain_tilemap")
	var tile_size = tilemap.tile_set.tile_size
	var cabin_tile_size : Vector2i = Vector2i(cabin.rect.size) / tile_size
	
	# constrain the cabin to a central-ish area
	var min_x_pos = map_width / 4
	var max_x_pos = map_width * 3 / 4
	var min_y_pos = map_height / 4
	var max_y_pos = map_height * 3 / 4
	
	var done = false
	while not done:
		
		#tile position of cabin (top-left corner)
		var cabin_x = randi_range(map_width / 4, map_width * 3 / 4)
		var cabin_y = randi_range(map_height / 4, map_height * 3 / 4)
		
		var incompatible_terrain = false
		for y in range(cabin_y, cabin_y + cabin_tile_size.y):
			if incompatible_terrain:
				break
			for x in range(cabin_x, cabin_x + cabin_tile_size.x):
				var tile : MapTileData = map_data[y][x]
				if tile.terrain_type in incompatible_terrain_types:
					incompatible_terrain = true
					break
		
		if !incompatible_terrain:
			var cabin_position = Vector2i(cabin_x, cabin_y) * tile_size
			generation_cache["cabin_position"] = cabin_position
			done = true
			
			for y in range(cabin_y, cabin_y + cabin_tile_size.y):
				for x in range(cabin_x, cabin_x + cabin_tile_size.x):
					var tile : MapTileData = map_data[y][x]
					tile.terrain_type = Globals.TerrainTileType.BUILDING
