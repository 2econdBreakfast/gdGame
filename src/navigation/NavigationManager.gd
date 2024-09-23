class_name TilemapNavigationManager extends NavigationRegion2D

#var terrain_tilemap: TileMap
#var obstacle_tilemap: TileMap
#
#var walkable_tile_atlas_coords : Array = [
	#Globals.TerrainTileType.FOREST_GRASS,
	#Globals.TerrainTileType.GRASS,
	#Globals.TerrainTileType.SAND,
	#Globals.TerrainTileType.SOIL,
	#Globals.TerrainTileType.RICH_SOIL,
#]
#
#var cabin : Node2D
#
#var walkable_tiles : Array
#var obstacles : Array
#
#func _on_map_generator_generation_complete():
	#terrain_tilemap = get_node(Paths.terrain_tilemap)
#
	#update_nav_region()
#
#func update_nav_region():
	#print("updating nav region")
	#var bounds = terrain_tilemap.get_used_rect()
	#var start = bounds.position
	#var end = bounds.position + bounds.size * terrain_tilemap.tile_set.tile_size
	#
	#print(start, end)
	#var nav_mesh_data : NavigationMeshSourceGeometryData2D = NavigationMeshSourceGeometryData2D.new()
	#
	#var nav_polygon = NavigationPolygon.new()
	#nav_polygon.add_outline([start, Vector2(start.x, end.y), end, Vector2(end.x, start.y)])
#
	#NavigationServer2D.bake_from_source_geometry_data(nav_polygon, nav_mesh_data);
	#self.navigation_polygon = nav_polygon
	#var nmaps = NavigationServer2D.get_maps()
	#var map = self.get_navigation_map()
	#print(map)
	#var b = true
	#
#
#func xform_packed_array(arr : PackedVector2Array, t : Transform2D) -> PackedVector2Array:
	#var result : PackedVector2Array = PackedVector2Array()
	#for point in arr:
		#var xformed = point + t.origin
		#var padding = 30 * Vector2(sign(xformed.x - t.get_origin().x), sign(xformed.y - t.get_origin().y))
		#result.append(xformed + padding)
	#return result
#
#
#
#
#


