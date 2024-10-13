class_name Shovel extends Tool

var grass_tiles = [Globals.TerrainTileType.GRASS, Globals.TerrainTileType.FOREST_GRASS]

func can_use(player : Player):
	if WORLD_DATA.terrain_tilemap:
		var target_tile_pos = player.get_tile_directly_ahead()
		#print("player_pos", player.get_current_tile_coordinates())
		#print("facing_dir", player.facing_dir)
		#print("facing_dir_int", player.facing_dir_int)
		#print("target_pos", target_tile_pos)		
		var target_tile = WORLD_DATA.terrain_tilemap.get_cell_atlas_coords(1, target_tile_pos)
		if target_tile in grass_tiles:
			#print("atlas_coords", target_tile)
			return true
	return false

func use(player : Player):
	var target_tile_pos = player.get_tile_directly_ahead()
	print(target_tile_pos)
	WORLD_DATA.terrain_tilemap.set_cell(1, target_tile_pos, 0, Globals.TerrainTileType.SOIL)
	WORLD_DATA.terrain_tilemap.queue_redraw()
