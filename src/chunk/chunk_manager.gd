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
var loaded_chunks: Array = []
var chunk_map: Array[Array] = []

var chunk_area2d: Area2D
var chunk_area2d_shape: CollisionShape2D

func initialize(generation_cache: Dictionary):
	var chunk_path = "user://chunks/"

	# Clear artifacts from last generation
	ChunkFileAccess.clear_chunk_directory(chunk_path)

	terrain_tilemap = generation_cache.get("terrain_tilemap")
	single_tile_size = terrain_tilemap.tile_set.tile_size

	# In standard Godot units
	chunk_actual_size = chunk_tile_size * single_tile_size

	var map_width = generation_cache.get("width")
	var map_height = generation_cache.get("height")

	var map_data: Array[Array] = generation_cache.get("map_data", [])
	var tree_dict = generation_cache.get("tree_dict", {})

	var chunk_map_size: Vector2i = Vector2i(map_width, map_height) / chunk_tile_size

	if debug:
		print("Map Size: ", chunk_map_size)
	initialize_chunk_map(map_data, tree_dict, chunk_map_size)

	initialize_chunk_area()

	var player_pos = get_node(Paths.player).global_position
	current_chunk = Vector2i(player_pos / chunk_actual_size)
	update_area2d_position()
	update_loaded_chunks()

func initialize_chunk_map(map_data: Array[Array], tree_dict: Dictionary, chunk_map_size: Vector2i):
	chunk_map.resize(chunk_map_size.y)
	for y in range(chunk_map_size.y):
		chunk_map[y] = []
		for x in range(chunk_map_size.x):
			var chunk: Chunk = create_chunk(x, y, map_data, tree_dict)
			chunk_map[y].append(chunk)

func create_chunk(x: int, y: int, map_data: Array[Array], tree_dict: Dictionary) -> Chunk:
	var chunk = Chunk.new(chunk_tile_size)
	chunk.y_sort_enabled = true
	# Store slice of map in chunk
	for y2 in range(chunk_tile_size):
		for x2 in range(chunk_tile_size):
			# Calculate actual position of tile in tilemap
			var map_y = y * chunk_tile_size + y2
			var map_x = x * chunk_tile_size + x2

			chunk.map_data[y2][x2] = map_data[map_y][map_x]
			var map_pos = Vector2i(map_x, map_y)
			if tree_dict.has(map_pos):
				chunk.object_data[Vector2i(x2, y2)] = tree_dict.get(map_pos, 0)
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
		print("Chunk map size: ", PackedByteArray(chunk_map).size())

	var chunks_to_load = get_chunks_to_load()
	var chunks_to_unload = get_chunks_to_unload(chunks_to_load)

	# Unload chunks
	for chunk_position in chunks_to_unload:
		unload_chunk(chunk_position)
	# Load chunks
	for chunk_position in chunks_to_load:
		if !loaded_chunks.has(chunk_position):
			load_chunk(chunk_position)

func get_chunk_count() -> int:
	var count = 0
	for row in chunk_map:
		for cell in row:
			if cell is Chunk:
				count += 1
	return count

func get_chunks_to_load() -> Array:
	var chunks_to_load: Array = []
	for delta_y in range(-chunk_load_distance, chunk_load_distance + 1):
		var y = current_chunk.y + delta_y
		if y >= 0 and y < chunk_map.size():
			for delta_x in range(-chunk_load_distance, chunk_load_distance + 1):
				var x = current_chunk.x + delta_x
				if x >= 0 and x < chunk_map[y].size():
					chunks_to_load.append(Vector2i(x, y))
	return chunks_to_load

func get_chunks_to_unload(chunks_to_load: Array) -> Array:
	var chunks_to_unload: Array = []
	for chunk_position in loaded_chunks:
		if !chunks_to_load.has(chunk_position):
			chunks_to_unload.append(chunk_position)
	return chunks_to_unload

func instantiate_chunk(chunk_position: Vector2i):
	var chunk = get_chunk_at_position(chunk_position)
	if chunk:
		chunk_container.add_child(chunk)
		tree_instantiator.instantiate(chunk, chunk_position, chunk_actual_size)
		return chunk
	else:
		if debug:
			print("Chunk at position", chunk_position, "is not valid or has been freed.")

func get_chunk_at_position(chunk_position: Vector2i) -> Chunk:
	var y = chunk_position.y
	var x = chunk_position.x
	if y >= 0 and y < chunk_map.size() and x >= 0 and x < chunk_map[y].size():
		var chunk = chunk_map[y][x]
		if chunk is Chunk and is_instance_valid(chunk):
			return chunk
	return null

func unload_chunk(chunk_position: Vector2i):
	if debug:
		print("Unloading chunk at ", chunk_position)

	var chunk = get_chunk_at_position(chunk_position)
	if chunk:
		var index = loaded_chunks.find(chunk_position)
		if index != -1:
			loaded_chunks.remove_at(index)
		# Save the chunk as a PackedScene
		ChunkFileAccess.save_chunk(chunk, chunk_position)
		chunk.queue_free()
		chunk_map[chunk_position.y][chunk_position.x] = null
	else:
		if debug:
			print("Chunk at ", chunk_position, " is already freed or invalid.")

func load_chunk(chunk_position: Vector2i):
	var chunk = ChunkFileAccess.load_chunk(chunk_position)
	if chunk:
		chunk_container.call_deferred("add_child", chunk)
		if debug:
			print("Loading saved chunk at ", chunk_position)
	else:
		chunk = instantiate_chunk(chunk_position)
		if debug:
			print("Initializing chunk at ", chunk_position)

	loaded_chunks.append(chunk_position)
	chunk_map[chunk_position.y][chunk_position.x] = chunk

func print_chunk_children(chunk):
	if chunk and debug:
		print("Chunk instantiated successfully.")
		print("Children of chunk: ", chunk.get_child_count())
		for child in chunk.get_children():
			print("Child: ", child.name, " - Class: ", child.get_class())
			for child2 in child.get_children():
				print("\tChild: ", child2.name, " - Class: ", child2.get_class())
