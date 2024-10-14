class_name TilemapHighlightManager extends Node
var TILEMAP_HIGHLIGHT_LAYER : int = 4
var TILE_HIGHLIGHT_SOURCE : int = 1
var EMPTY_TILE : Vector2i = Vector2i(-1, -1)
var VALID_TILE : Vector2i = Vector2i(0, 0)
var INVALID_TILE : Vector2i = Vector2i(1, 0)

var highlighted_tiles : Dictionary = {}

func highlight(tile_position : Vector2i, valid : bool):
	var tile_atlas_coords = VALID_TILE if valid else INVALID_TILE
	WORLD_DATA.terrain_tilemap.set_cell(TILEMAP_HIGHLIGHT_LAYER, tile_position, TILE_HIGHLIGHT_SOURCE, tile_atlas_coords )
	highlighted_tiles[tile_position] = tile_atlas_coords
	
func remove_highlight(tile_position : Vector2i):
	WORLD_DATA.terrain_tilemap.erase_cell(TILEMAP_HIGHLIGHT_LAYER, tile_position)
	if highlighted_tiles.has(tile_position):
		highlighted_tiles.erase(tile_position)

func clear_highlighted():
	WORLD_DATA.terrain_tilemap.clear_layer(TILEMAP_HIGHLIGHT_LAYER)
	highlighted_tiles.clear()
	
