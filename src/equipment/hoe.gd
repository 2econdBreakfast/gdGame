class_name Hoe extends Tool

var grass_tiles = [Globals.TerrainTileType.GRASS, Globals.TerrainTileType.FOREST_GRASS]

var target_tile_position : Vector2i
func _init(player : Player):
	self.player = player
	self.tool_name = "Hoe"

func _process(delta):
	super._process(delta)
	if not self.active: return
	
	var is_valid = can_use()
	
	var tile_directly_ahead = self.player.get_tile_directly_ahead()
	
	if tile_directly_ahead != target_tile_position:
		TILE_HIGHLIGHTER.clear_highlighted()
		TILE_HIGHLIGHTER.highlight(tile_directly_ahead, is_valid)
	
	# don't allow usage before delay is done, or if tile is invalid
	if not self.usage_delay_finished() or not is_valid: 
		return

	if Input.is_action_just_pressed("use_tool"):
		use()
func can_use():
	if WORLD_DATA.terrain_tilemap:
		var target_tile_pos = player.get_tile_directly_ahead()
		var target_tile_soil_layer = WORLD_DATA.terrain_tilemap.get_cell_atlas_coords(2, target_tile_pos)
		if target_tile_soil_layer != Vector2i(-1, -1):
			return false

		var target_tile_terrain_layer = WORLD_DATA.terrain_tilemap.get_cell_atlas_coords(1, target_tile_pos)

		if target_tile_terrain_layer in grass_tiles:
			return true
	return false

func use():
	var target_tile_pos = player.get_tile_directly_ahead()
	print(target_tile_pos)
	WORLD_DATA.terrain_tilemap.set_cell(2, target_tile_pos, 0, Globals.TerrainTileType.SOIL)

func on_deactivate():
	TILE_HIGHLIGHTER.clear_highlighted()
