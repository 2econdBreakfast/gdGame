extends Node2D

class_name MapGenerator

@export var debug : bool = false

@onready var generator_modules = get_node("GeneratorModules").get_children()
@onready var instantiator_modules = get_node("InstantiatorModules").get_children()

# generation parameters / members
@export var map_size : Vector2i = Vector2i(1024, 1024)
@export var max_threads : int = 4
@onready var terrain_tilemap : TileMap = get_node("Tilemaps/TerrainTilemap")
@onready var chunk_manager : ChunkManager = get_node("ChunkManager")

var generation_cache : Dictionary = {} # store any data needed for generation

signal generation_started
signal generation_complete
signal instantiation_started
signal instantiation_complete

func _ready():
	generate_and_instantiate()

func generate_and_instantiate():
	generation_started.emit()	
	if debug:
		print("MapGenerator: generating...")
		Debug.Memory.print_mem_usage("Memory usage before generation")
	
	if debug:
		print("MapGenerator: instantiating...")
		Debug.Memory.print_mem_usage("Memory usage after generation")
	
	generation_cache["width"] = map_size.x
	generation_cache["height"] = map_size.y
	generation_cache["max_threads"] = max_threads
	generation_cache["terrain_tilemap"] = terrain_tilemap
	for module : GeneratorModule in generator_modules:
		if module.enabled:
			module.generate(generation_cache)
	

	for module : InstantiatorModule in instantiator_modules:
		if module.enabled:
			module.instantiate(generation_cache)
		
	chunk_manager.initialize(generation_cache)
	instantiation_complete.emit()
	
	if debug:
		Debug.Memory.print_mem_usage("Memory usage after clearing cache")
		print("MapGenerator: clearing generation cache...")
		print("MapGenerator: done")
	
	generation_complete.emit()
