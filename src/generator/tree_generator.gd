class_name TreeGenerator extends GeneratorModule

@export var rainfall_weight = 0.5
@export var terrain_type_weight = 0.5

var incompatible_terrain = [Globals.TerrainTileType.WATER, Globals.TerrainTileType.DEEP_WATER, Globals.TerrainTileType.BUILDING]

var terrain_chance_map : Dictionary = {
	Biomes.PLAINS.terrain_atlas_coords : 0.2,
	Biomes.FOREST.terrain_atlas_coords : 0.4,
	Biomes.BEACH.terrain_atlas_coords : 0.05
}
func generate(generation_cache : Dictionary):
	var width = generation_cache.get("width")
	var height = generation_cache.get("height")
	var map_data : Array[Array] = generation_cache.get("map_data")
	var tree_dict : Dictionary = {}

	for y in range(height):
		for x in range(width):
			var tile_data : MapTileData = map_data[y][x]
				
			# don't put trees on incompatible tiles
			if tile_data.terrain_type in incompatible_terrain:
				continue
				
			var tree
			var biome : BiomeData = Biomes.get_biome_by_id(tile_data.biome)
			if biome:
				tree = biome.get_random_tree()
			if tree:
				var tree_chance = biome.fertility
				if tree_chance > randf_range(0, 1):
					tree_dict[Vector2i(x, y)] = tree
	
	generation_cache["tree_dict"] = tree_dict
