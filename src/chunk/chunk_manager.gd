# ChunkManager.gd

class_name ChunkManager extends Node

@export var chunk_tile_size: int = 8
@export var chunk_load_distance: int = 1
@export var tree_instantiator: ChunkTreeInstantiator
@export var chunk_container: Node2D
@export var debug: bool = false

@export var highlight_current_chunk: bool:
	set(value):
		if chunk_area2d:
			chunk_area2d.visible = value
	get:
		if chunk_area2d:
			return chunk_area2d.visible
		else:
			return false

var chunk_actual_size: Vector2
var single_tile_size: Vector2i
var terrain_tilemap: TileMap

var current_chunk: Vector2i
var loaded_chunks = {}  # Dictionary of loaded chunks

var chunk_area2d: Area2D
var chunk_area2d_shape: CollisionShape2D

func initialize():
	var chunk_path = "user://chunks/"

	terrain_tilemap = WORLD_DATA.terrain_tilemap
	single_tile_size = terrain_tilemap.tile_set.tile_size

	# In standard Godot units
	chunk_actual_size = chunk_tile_size * single_tile_size

	var map_width = WORLD_DATA.cache.get("width")
	var map_height = WORLD_DATA.cache.get("height")

	var map_data: Array[Array] = WORLD_DATA.cache.get("map_data", [])
	var tree_array = WORLD_DATA.cache.get("tree_array", [])

	var chunk_map_size: Vector2i = Vector2i(map_width / chunk_tile_size, map_height / chunk_tile_size)

	if debug:
		print("Map Size: ", chunk_map_size)
	
	# Preprocess tree data to assign to chunks
	var chunk_tree_data = preprocess_tree_data(tree_array)
	initialize_chunks(map_data, chunk_tree_data, chunk_map_size)

	initialize_chunk_area()

	var player_pos = get_node(Paths.player).global_position
	current_chunk = Vector2i(player_pos / chunk_actual_size)
	update_area2d_position()
	update_loaded_chunks()

func preprocess_tree_data(tree_array: Array[TreeData]) -> Dictionary:
	var chunk_tree_data = {}
	for tree_data in tree_array:
		var chunk_pos = Vector2i(tree_data.position / chunk_tile_size)
		var key = "%d_%d" % [chunk_pos.x, chunk_pos.y]
		if not chunk_tree_data.has(key):
			chunk_tree_data[key] = []
		chunk_tree_data[key].append(tree_data)
	return chunk_tree_data

func initialize_chunks(map_data: Array[Array], chunk_tree_data: Dictionary, chunk_map_size: Vector2i):
	for y in range(chunk_map_size.y):
		for x in range(chunk_map_size.x):
			var chunk: Chunk = create_chunk(x, y, map_data)
			# Assign TreeData to chunk if any
			var key = "%d_%d" % [x, y]
			if chunk_tree_data.has(key):
				chunk.object_data = chunk_tree_data[key]
			# Save chunk to file
			ChunkMemoryAccess.save_chunk(chunk, Vector2i(x, y))
			# Unload chunk
			chunk.queue_free()
			chunk = null
			if debug:
				print("Chunk at (%d, %d) saved and unloaded." % [x, y])

func create_chunk(x: int, y: int, map_data: Array[Array]) -> Chunk:
	var chunk = Chunk.new()
	chunk.initialize(chunk_tile_size)
	chunk.y_sort_enabled = true
	# Store slice of map in chunk
	for y2 in range(chunk_tile_size):
		chunk.map_data.append([])
		for x2 in range(chunk_tile_size):
			# Calculate actual position of tile in tilemap
			var map_y = y * chunk_tile_size + y2
			var map_x = x * chunk_tile_size + x2
			chunk.map_data[y2].append(map_data[map_y][map_x])
	return chunk

func initialize_chunk_area():
	chunk_area2d = get_node("ChunkArea")
	chunk_area2d_shape = chunk_area2d.get_node("CollisionShape2D")
	self.highlight_current_chunk = self.highlight_current_chunk  # Update visibility based on exported variable

	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = chunk_actual_size
	chunk_area2d_shape.shape = rect

func _process(delta):
	update_current_chunk()

func update_current_chunk():
	var player_pos = get_node(Paths.player).global_position
	var new_current_chunk = Vector2i(player_pos / chunk_actual_size)
	if new_current_chunk != current_chunk:
		current_chunk = new_current_chunk
		update_area2d_position()
		update_loaded_chunks()

func update_area2d_position():
	chunk_area2d.global_position = Vector2(current_chunk) * chunk_actual_size + (chunk_actual_size / 2)

func _on_chunk_area_body_exited(body):
	if body.name == "Player":
		update_current_chunk()

func update_loaded_chunks():
	# Determine which chunks should be loaded
	if debug:
		print("\n\n\nSTEP===\n")

	if debug:
		var count = get_chunk_count()
		print("Chunks in memory: ", count)

	var chunks_to_load = get_chunks_to_load()
	var chunks_to_unload = get_chunks_to_unload(chunks_to_load)

	# Unload chunks
	for chunk_position in chunks_to_unload:
		unload_chunk(chunk_position)
	# Load chunks
	for chunk_position in chunks_to_load:
		if not loaded_chunks.has(chunk_position):
			load_chunk(chunk_position)

func get_chunk_count() -> int:
	return loaded_chunks.size()

func get_chunks_to_load() -> Array:
	var chunks_to_load: Array = []
	for delta_y in range(-chunk_load_distance, chunk_load_distance + 1):
		var y = current_chunk.y + delta_y
		if y >= 0 and y < world_chunk_size().y:
			for delta_x in range(-chunk_load_distance, chunk_load_distance + 1):
				var x = current_chunk.x + delta_x
				if x >= 0 and x < world_chunk_size().x:
					chunks_to_load.append(Vector2i(x, y))
	return chunks_to_load

func get_chunks_to_unload(chunks_to_load: Array) -> Array:
	var chunks_to_unload: Array = []
	for chunk_position in loaded_chunks.keys():
		if not chunks_to_load.has(chunk_position):
			chunks_to_unload.append(chunk_position)
	return chunks_to_unload

func world_chunk_size() -> Vector2i:
	# Returns the size of the world in chunks
	var map_width = WORLD_DATA.cache.get("width")
	var map_height = WORLD_DATA.cache.get("height")
	return Vector2i(map_width / chunk_tile_size, map_height / chunk_tile_size)

func get_chunk_at_position(chunk_position: Vector2i) -> Chunk:
	if loaded_chunks.has(chunk_position):
		var chunk = loaded_chunks[chunk_position]
		if is_instance_valid(chunk):
			return chunk
	return null

func load_chunk(chunk_position: Vector2i):
	if loaded_chunks.has(chunk_position):
		return  # Chunk is already loaded
	var chunk = ChunkMemoryAccess.load_chunk(chunk_position)
	Debug.Memory.print_mem_usage()
	if chunk:
		chunk_container.call_deferred("add_child", chunk)
		if debug:
			print("Loading saved chunk at ", chunk_position)
		loaded_chunks[chunk_position] = chunk
		# Instantiate trees or other objects
		tree_instantiator.instantiate(chunk, chunk_position, chunk_actual_size)
	else:
		if debug:
			print("Failed to load chunk at ", chunk_position)

func unload_chunk(chunk_position: Vector2i):
	if debug:
		print("Unloading chunk at ", chunk_position)
	if loaded_chunks.has(chunk_position):
		var chunk = loaded_chunks[chunk_position]
		# Save the chunk data
		ChunkMemoryAccess.save_chunk(chunk, chunk_position)
		chunk.queue_free()
		loaded_chunks.erase(chunk_position)
	else:
		if debug:
			print("Chunk at ", chunk_position, " is not loaded.")

func print_chunk_children(chunk):
	if chunk and debug:
		print("Chunk instantiated successfully.")
		print("Children of chunk: ", chunk.get_child_count())
		for child in chunk.get_children():
			print("Child: ", child.name, " - Class: ", child.get_class())
			for child2 in child.get_children():
				print("\tChild: ", child2.name, " - Class: ", child2.get_class())
