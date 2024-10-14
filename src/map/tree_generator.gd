class_name TreeGenerator extends GeneratorModule

@export var rainfall_weight = 0.5
@export var terrain_type_weight = 0.5

var incompatible_terrain = [Globals.TerrainTileType.WATER, Globals.TerrainTileType.DEEP_WATER, Globals.TerrainTileType.BUILDING]

var terrain_chance_map : Dictionary = {
	Biomes.PLAINS.terrain_atlas_coords : 0.2,
	Biomes.FOREST.terrain_atlas_coords : 0.4,
	Biomes.BEACH.terrain_atlas_coords : 0.05
}
func generate():
	var width = WORLD_DATA.cache.get("width")
	var height = WORLD_DATA.cache.get("height")
	var map_data : Array[Array] = WORLD_DATA.cache.get("map_data")
	var tree_array : Array[TreeData] = []

	for y in range(height):
		for x in range(width):
			var tile_data : MapTileData = map_data[y][x]
				
			# don't put trees on incompatible tiles
			if tile_data.terrain_type in incompatible_terrain:
				continue
				
			var tree_type : int
			var biome : BiomeData = Biomes.get_biome_by_id(tile_data.biome)
			if biome.terrain_atlas_coords in incompatible_terrain:
				break
			if biome:
				tree_type = biome.get_random_tree()
			if tree_type:
				var tree_chance = biome.fertility
				if tree_chance > randf_range(0, 1):
					var tree_data : TreeData = TreeData.new(tree_type, 0, Vector2(x, y))
					tree_array.append(tree_data)
	
	WORLD_DATA.cache["tree_array"] = tree_array
