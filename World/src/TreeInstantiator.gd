class_name TreeInstantiator extends InstantiatorModule

var tree_layer = 0
var tree_layer_name = "Trees"
var tree_source = 0;


func instantiate(generation_cache : Dictionary):
	var terrain_tilemap : TileMap = generation_cache["terrain_tilemap"]
	var destructible_tilemap : TileMap = generation_cache["destructible_tilemap"]
	var tree_map : Array = generation_cache["tree_map"]
	var terrain_map : Array[Array] = generation_cache["terrain_map"]
	var biome_map : Array[Array] = generation_cache["biome_map"];
	
	var tree_layer : int = TileMapTools.get_layer_id_from_name(destructible_tilemap, tree_layer_name)
	
	for tree_world_pos in tree_map:
		var tree_type
		var biome_type = biome_map[tree_world_pos.y][tree_world_pos.x]
		var biome : BiomeData
		
		match(biome_type):
			Globals.Biome.FOREST: biome = Biomes.FOREST
			Globals.Biome.PLAINS: biome = Biomes.PLAINS
			Globals.Biome.BEACH: biome = Biomes.BEACH
			_: continue
			
		tree_type = biome.get_random_tree()
		
		destructible_tilemap.set_cell(tree_layer, tree_world_pos, tree_source, tree_type)
