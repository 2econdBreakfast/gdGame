extends NavigationRegion2D

class_name TilemapNavigationManager

var terrain_tilemap: TileMap
var obstacle_tilemap: TileMap

var walkable_tile_atlas_coords : Array = [
	Globals.TileCoords.FOREST_GRASS,
	Globals.TileCoords.GRASS,
	Globals.TileCoords.SAND,
	Globals.TileCoords.SOIL,
	Globals.TileCoords.RICH_SOIL,
]

var cabin : Node2D

var walkable_tiles : Array
var obstacles : Array


func _on_map_generator_instantiation_complete():
	terrain_tilemap = get_node(Paths.terrain_tilemap)
	obstacle_tilemap = get_node(Paths.destructible_tilemap)
	cabin = get_node(Paths.cabin)
	update_nav_region()
	

func update_nav_region():
	print("updating nav region")
	var bounds = terrain_tilemap.get_used_rect()
	var start = bounds.position
	var end = bounds.position + bounds.size * terrain_tilemap.tile_set.tile_size
	
	print(start, end)
	var nav_mesh_data : NavigationMeshSourceGeometryData2D = NavigationMeshSourceGeometryData2D.new()

	var nav_polygon = NavigationPolygon.new()
	# Create a navigation polygon that covers the entire bounds of the terrain tilemap
	var poly_points = [
		start,
		Vector2(start.x + end.x, start.y),
		start + end,
		Vector2(start.x, start.y + end.y)
	]
	nav_mesh_data.add_traversable_outline(poly_points)
	nav_polygon.make_polygons_from_outlines()


	
	var cabin_outline : CollisionPolygon2D = cabin.get_node("InteriorArea2D/CollisionPolygon2D")
	
	nav_mesh_data.add_obstruction_outline(xform_packed_array(cabin_outline.polygon, cabin_outline.global_transform))

	NavigationServer2D.bake_from_source_geometry_data(nav_polygon, nav_mesh_data);
	self.navigation_polygon = nav_polygon
	

func xform_packed_array(arr : PackedVector2Array, t : Transform2D) -> PackedVector2Array:
	var result : PackedVector2Array = PackedVector2Array()
	for point in arr:
		var xformed = point + t.origin
		var padding = 30 * Vector2(sign(xformed.x - t.get_origin().x), sign(xformed.y - t.get_origin().y))
		result.append(xformed + padding)
	return result



