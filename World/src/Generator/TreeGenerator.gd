class_name TreeGenerator extends GeneratorModule

@export var rainfall_weight = 0.5
@export var terrain_type_weight = 0.5

var terrain_chance_map : Dictionary = {
	Biomes.PLAINS.terrain_atlas_coords : 0.1,
	Biomes.FOREST.terrain_atlas_coords : 0.2,
	Biomes.BEACH.terrain_atlas_coords : 0.05
}
func generate(generation_cache : Dictionary):
	var rainfall_map = generation_cache["rainfall_map"]
	var terrain_map = generation_cache["terrain_map"]
	
	print(terrain_map.size())
	generation_cache["tree_map"] = []
	for y in range(terrain_map.size()):
		for x in range(terrain_map[0].size()):
			var terrain_type : Vector2i = terrain_map[y][x]
			
			if terrain_chance_map.has(terrain_type):
				var rainfall_amount: float = rainfall_map[y][x]
				var tree_chance = rainfall_amount * rainfall_weight + terrain_chance_map[terrain_type] * terrain_type_weight
				if tree_chance > randf_range(0, 1):
					generation_cache["tree_map"].append(Vector2i(x, y))
