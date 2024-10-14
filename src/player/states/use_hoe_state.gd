class_name UseHoeState extends State

var tilemap_highlight_layer : int = 4
var target_tile_position : Vector2i
var TILE_HIGHLIGHT_SOURCE : int = 1
var EMPTY_TILE : Vector2i = Vector2i(-1, -1)
var YES_TILE : Vector2i = Vector2i(0, 0)
var INVALID_TILE : Vector2i = Vector2i(1, 0)

func process_input() -> State:

	
	return self

func update_target_tile(tile_position : Vector2i, tile_atlas_coords : Vector2i):
	WORLD_DATA.terrain_tilemap.set_cell(tilemap_highlight_layer, target_tile_position, TILE_HIGHLIGHT_SOURCE, EMPTY_TILE)
	self.target_tile_position = tile_position
	WORLD_DATA.terrain_tilemap.set_cell(tilemap_highlight_layer, target_tile_position, TILE_HIGHLIGHT_SOURCE, tile_atlas_coords )
	
