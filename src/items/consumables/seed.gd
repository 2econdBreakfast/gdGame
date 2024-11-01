class_name Seed extends ConsumableItemData

var seed_atlas_coords : Vector2i


func can_use():
	var tile_ahead = Player.instance.get_tile_directly_ahead()
	
	var soil_tile_ahead = WORLD_DATA.terrain_tilemap.get_cell_atlas_coords(
		Globals.TileMapLayers.SOIL,
		tile_ahead,
		Globals.TileMapSource.TERRAIN
	)
	
	if soil_tile_ahead == Globals.TerrainTileType.NONE:
		return false
		
	var plant_tile_ahead = WORLD_DATA.terrain_tilemap.get_cell_atlas_coords(
		Globals.TileMapLayers.PLANTS,
		tile_ahead,
		Globals.TileMapSource.TERRAIN
	)
	
	if plant_tile_ahead != Globals.TerrainTileType.NONE:
		return false
	
	return true

func use():
	var tile_ahead = Player.instance.get_tile_directly_ahead()
		
	var soil_tile_ahead = WORLD_DATA.terrain_tilemap.get_cell_atlas_coords(
		Globals.TileMapLayers.SOIL,
		tile_ahead,
		Globals.TileMapSource.TERRAIN
	)
	
	var plant_tile_ahead = WORLD_DATA.terrain_tilemap.get_cell_atlas_coords(
		Globals.TileMapLayers.PLANTS,
		tile_ahead,
		Globals.TileMapSource.TERRAIN
	)
	
	plant_tile_ahead
func on_activate():
	Player.instance.enable_interaction(self.can_use)

func on_deactivate():
	Player.instance.disable_interaction()
