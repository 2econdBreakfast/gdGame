extends Node2D

class_name MapGenerator

@export var debug : bool = false

@export var generator_modules : Array[GeneratorModule] = []
@export var instantiator_modules : Array[InstantiatorModule] = []
# generation parameters / members
@export var map_size : Vector2i = Vector2i(1024, 1024)
@export var max_threads : int = 4
@onready var terrain_tilemap : TileMap = get_node("../Tilemaps/TerrainTilemap")
@onready var destructible_tilemap : TileMap = get_node("../Tilemaps/DestructibleTilemap")

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
	
	var t1; var t2; var t_total; #debug variables
	generation_cache["width"] = map_size.x
	generation_cache["height"] = map_size.y
	generation_cache["max_threads"] = max_threads
	
	for module : GeneratorModule in generator_modules:
		module.generate(generation_cache)
	
	generation_cache["terrain_tilemap"] = terrain_tilemap
	generation_cache["destructible_tilemap"] = destructible_tilemap
	for module : InstantiatorModule in instantiator_modules:
		module.instantiate(generation_cache)
	
	if debug:
		Debug.Memory.print_mem_usage("Memory usage after clearing cache")
		print("MapGenerator: clearing generation cache...")
		print("MapGenerator: done")
	
	generation_complete.emit()
