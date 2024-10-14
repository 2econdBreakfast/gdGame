extends NavigationRegion2D

class_name TilemapNavigationManager
@export var disabled : bool = false
var terrain_tilemap: TileMap
var obstacle_tilemap: TileMap

var walkable_tile_atlas_coords : Array = [
	Globals.TerrainTileType.FOREST_GRASS,
	Globals.TerrainTileType.GRASS,
	Globals.TerrainTileType.SAND,
	Globals.TerrainTileType.SOIL,
	Globals.TerrainTileType.RICH_SOIL,
]

var cabin : Node2D

var walkable_tiles : Array
var obstacles : Array

func _on_map_generator_generation_complete():
	terrain_tilemap = get_node(Paths.terrain_tilemap)
	if not disabled:
		update_nav_region()

func update_nav_region():
	print("updating nav region")
	var bounds = terrain_tilemap.get_used_rect()
	var start = bounds.position
	var end = bounds.position + bounds.size * terrain_tilemap.tile_set.tile_size
	
	print(start, end)
	var nav_mesh_data : NavigationMeshSourceGeometryData2D = NavigationMeshSourceGeometryData2D.new()
	
	walkable_tiles = []
	for tile_atlas_coords in walkable_tile_atlas_coords:
		var tiles = terrain_tilemap.get_used_cells_by_id(1, 0, tile_atlas_coords)
		walkable_tiles.append_array(tiles)
	
	var tile_size = WORLD_DATA.terrain_tilemap.tile_set.tile_size
	
	var nav_polygon = NavigationPolygon.new()
	print("Walkable ", walkable_tiles.size())
	for tile_pos in walkable_tiles:
		var poly = terrain_tilemap.get_cell_tile_data(1, tile_pos).get_navigation_polygon(0).get_outline(0)
		nav_polygon.add_outline(poly)
	print("nav_poly: ", nav_polygon.get_polygon_count())

		
	NavigationServer2D.bake_from_source_geometry_data(nav_polygon, nav_mesh_data);
	self.navigation_polygon = nav_polygon
	
	terrain_tilemap.set_layer_navigation_enabled(1, false)
	

func xform_packed_array(arr : PackedVector2Array, t : Transform2D) -> PackedVector2Array:
	var result : PackedVector2Array = PackedVector2Array()
	for point in arr:
		var xformed = point + t.origin
		var padding = 30 * Vector2(sign(xformed.x - t.get_origin().x), sign(xformed.y - t.get_origin().y))
		result.append(xformed + padding)
	return result







