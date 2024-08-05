extends Node2D

class_name MapGenerator


# generation parameters / members
@export var map_size : Vector2i = Vector2i(256, 256)
@onready var terrain_tilemap : TileMap = get_node(Paths.terrain_tilemap)
@onready var destructible_tilemap : TileMap = get_node(Paths.destructible_tilemap)
var generation_cache : Dictionary = {} # store any data needed for generation

signal generation_started
signal generation_complete
signal instantiation_started
signal instantiation_complete

# debug only
@export var test_mode : bool

func _ready():
	if test_mode:
		test_generate_and_save_images(100)
	else:
		generate_and_instantiate()


func generate_and_instantiate():
	print("MapGenerator: generating...")
	generate_map()
	print("MapGenerator: instantiating...")
	instantiate_map()
	print("MapGenerator: clearing generation cache...")
	generation_cache.clear()
	print("MapGenerator: done")


## GENERATION

func generate_map():
	generation_started.emit()
	generation_cache["heightmap"] = HeightmapGenerator.generate_heightmap(map_size.x, map_size.y)
	# generate intial terrain
	generation_cache["terrain_image"] = TerrainGenerator.terrain_from_heightmap(generation_cache["heightmap"])
	#add rivers
	generation_cache["terrain_image"] = generate_river(generation_cache["terrain_image"], generation_cache["heightmap"])
	# generate tree placements
	var tree_gen : TreeGenerator = TreeGenerator.new()
	generation_cache["tree_map"] = tree_gen.generate_flora(generation_cache["terrain_image"])
	generation_complete.emit()

func generate_river(map : Image, heightmap : Image) -> Image:
	var new_map = map.duplicate(true)	
	var river_generator = RiverGenerator.new()
	river_generator.m_maximum_width = 6;
	river_generator.m_bounds = map.get_size()
	var max_starting_rivers = 6
	river_generator.generate(max_starting_rivers, 3, heightmap)
	var river_points = river_generator.get_final_river_points(map.get_size())
	for branch in river_points:
		for point in branch:
			if VectorTools.a_inside_b(point, map.get_size()):
				var terrain_color = map.get_pixelv(point)
				if terrain_color.is_equal_approx(Palettes.DEEP_WATER_COLOR) \
					or terrain_color.is_equal_approx(Palettes.DEEP_WATER_COLOR):
					break;
				else:
					new_map.set_pixelv(point, Palettes.WATER_COLOR)
	return new_map


## INSTANTIATION

func instantiate_map():
	instantiation_started.emit()
	instantiate_terrain()
	instantiate_trees()
	instantiation_complete.emit()

func instantiate_terrain():
	var terrain_instantiator : TerrainInstantiator = TerrainInstantiator.new()
	terrain_instantiator.m_tilemap = terrain_tilemap
	terrain_instantiator.image_to_tilemap(generation_cache["terrain_image"])
	terrain_instantiator.queue_free()


func instantiate_trees():
	var tree_instantiator = TreeInstantiator.new()
	tree_instantiator.tilemap = destructible_tilemap
	tree_instantiator.terrain_tilemap = terrain_tilemap
	tree_instantiator.place_trees_at_points(generation_cache["tree_map"])
	tree_instantiator.queue_free()


## DEBUG ##
func test_generate_and_save_images(iterations : int, out_dir : String = "res://tests/test"):
	var out_dir_name = out_dir
	var i = 1
	var dir = DirAccess.open("res://")
	while dir.dir_exists(out_dir_name):
		out_dir_name = out_dir + var_to_str(i)
		i += 1
	dir.make_dir(out_dir_name)
	var tTotal = 0
	for j in range(iterations):
		var t1 = Time.get_ticks_usec()
		generate_map()
		var t2 = Time.get_ticks_usec()
		tTotal += (t2 - t1)
		var path = out_dir_name + "/output_" + var_to_str(j) + ".jpg"
		generation_cache["terrain_image"].save_jpg((path), 0.5);
		print(var_to_str(j + 1) + " out of " + var_to_str(iterations) + " complete in " + var_to_str(float(t2 - t1) / 1000000) + " seconds.")
	print("=== RESULTS ===")
	print(var_to_str(iterations) + " completed in " + var_to_str(tTotal / 1000000.0) + " seconds total.")
