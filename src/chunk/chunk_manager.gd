class_name ChunkManager extends Node

@export var chunk_tile_size : int = 8
@export var chunk_load_distance : int = 1
@export var tree_instantiator : ChunkTreeInstantiator
@export var chunk_container : Node2D

@export var highlight_current_chunk : bool:
	set(v):
		if chunk_area2d:
			chunk_area2d.visible = v
	get:
		if chunk_area2d:
			return chunk_area2d.visible
		else:
			return false
var chunk_actual_size : Vector2
var chunk_area2d : Area2D
var chunk_area2d_shape : CollisionShape2D
var chunk_area2d_dimensions : Vector2
var single_tile_size : Vector2i
var terrain_tilemap : TileMap

var current_chunk : Vector2i
var loaded_chunks : Array = []
var chunk_map : Array[Array]  = []


func initialize(generation_cache : Dictionary):
	var chunkpath = "user://chunks/"
	
	# clear artifacts from last generation
	var dir = DirAccess.open(chunkpath)
	for file in dir.get_files():
		dir.remove(file)
	
	terrain_tilemap = generation_cache.get("terrain_tilemap")
	single_tile_size = terrain_tilemap.tile_set.tile_size

	# in standard godot units
	chunk_actual_size = chunk_tile_size * single_tile_size
	
	var map_width = generation_cache.get("width")
	var map_height = generation_cache.get("height")
	
	var map_data : Array[Array] = generation_cache.get("map_data", [])

	var tree_dict = generation_cache.get("tree_dict", {})
	
	var chunk_map_size : Vector2i = Vector2i(map_width, map_height) / chunk_tile_size
	
	print("Map Size: ", chunk_map_size)
	chunk_map.resize(chunk_map_size.y)
	for y in range(chunk_map_size.y):
		chunk_map[y].resize(chunk_map_size.y)
		for x in range(chunk_map_size.x):
			var chunk : Chunk = Chunk.new(chunk_tile_size)
			chunk.y_sort_enabled = true
			# store slice of map in chunk
			for y2 in range(chunk_tile_size):
				for x2 in range(chunk_tile_size):
					# calculate actual position of tile in tilemap
					var map_y = y * chunk_tile_size + y2
					var map_x = x * chunk_tile_size + x2
					
					chunk.map_data[y2][x2] = map_data[map_y][map_x]
					var map_pos = Vector2i(map_x, map_y)
					if tree_dict.has(map_pos):
						chunk.object_data[Vector2i(x2, y2)] = tree_dict.get(map_pos, 0)
			# Add the chunk to the chunk map
			chunk_map[y][x] = chunk

	chunk_area2d = get_node("ChunkArea")
	chunk_area2d_shape = chunk_area2d.get_node("CollisionShape2D")
	self.highlight_current_chunk = self.highlight_current_chunk
	
	
	var player_pos = get_node(Paths.player).global_position
	
	var current_chunk = Vector2i(player_pos / chunk_actual_size)
	
	var rect : RectangleShape2D = RectangleShape2D.new()
	rect.size = chunk_actual_size
	chunk_area2d_shape.shape = rect
	
	update_area2d_position()
	update_loaded_chunks()
	
func update_area2d_position():
	var player_pos = get_node(Paths.player).global_position
	current_chunk = Vector2i(player_pos / chunk_actual_size)
	chunk_area2d.global_position = Vector2(current_chunk) * chunk_actual_size + (chunk_actual_size / 2)
	
func _on_chunk_area_body_exited(body):
	if body.name == "Player":
		update_area2d_position()
		update_loaded_chunks()
	
func update_loaded_chunks():
	#determine which chunks should be loaded
	print("\n\n\nSTEP===\n")
	var count = 0
	for row in chunk_map:
		for cell in row:
			if cell is Chunk:
				count += 1
	
	print("chunks in memory: ", count)
	print("chunkmap size: ", PackedByteArray(chunk_map).size())

	var chunks_to_load : Array = []
	for delta_y in range(-chunk_load_distance, chunk_load_distance + 1):
		var y = current_chunk.y + delta_y
		if y >=0 and y < chunk_map.size():
			for delta_x in range(-chunk_load_distance, chunk_load_distance + 1):
				var x = current_chunk.x + delta_x
				if x >=0 and x < chunk_map[x].size():
					chunks_to_load.append(Vector2i(x, y))

	# determine which chunks should be unloaded
	var chunks_to_unload : Array = []
	for chunk_position in loaded_chunks:
		if !chunks_to_load.has(chunk_position):
			chunks_to_unload.append(chunk_position)
	
	
	# unload chunks
	for chunk_position in chunks_to_unload:
		unload_chunk(chunk_position)
	# load chunks
	for chunk in chunks_to_load:
		if !loaded_chunks.has(chunk):
			load_chunk(chunk)

func instantiate_chunk(chunk_position : Vector2i):
	var y = int(chunk_position.y)
	var x = int(chunk_position.x)
	if y >= 0 and y < chunk_map.size() and x >= 0 and x < chunk_map[y].size():
		var chunk = chunk_map[y][x]

		if chunk is Chunk and is_instance_valid(chunk):
			
			chunk_container.add_child(chunk)
			tree_instantiator.instantiate(chunk, chunk_position, chunk_actual_size)
			

			save_chunk(chunk_position)
			return chunk
			
		else:
			print("Chunk at position", chunk_position, "is not valid or has been freed.")
			# Consider reloading or reconstructing the chunk here if necessary
	else:
		print("Chunk position out of range or not initialized:", chunk_position)
	
	
func unload_chunk(chunk_position: Vector2i):
	print("Unloading chunk at ", chunk_position)

	var y = int(chunk_position.y)
	var x = int(chunk_position.x)
	if y >= 0 and y < chunk_map.size() and x >= 0 and x < chunk_map[y].size():
		var chunk = chunk_map[y][x]
		if chunk and is_instance_valid(chunk):
			var index = loaded_chunks.find(chunk_position)
			if index != -1:
				loaded_chunks.remove_at(index)
			save_chunk(chunk_position)
			chunk.queue_free()
			chunk_map[y][x] = null
		else:
			print("Chunk at ", chunk_position, " is already freed or invalid.")
	else:
		print("Chunk position out of bounds: ", chunk_position)

func load_chunk(chunk_position : Vector2i):
	var chunk_saved_data : PackedScene = load_from_file_if_exists(chunk_position)
	var chunk
	if chunk_saved_data and chunk_saved_data.can_instantiate():
		chunk = chunk_saved_data.instantiate()
		chunk_container.call_deferred("add_child", chunk)
		print("loading saved chunk at ", chunk_position)
	else:
		chunk = instantiate_chunk(chunk_position)
		print("initializing chunk at ", chunk_position)
	
	loaded_chunks.append(chunk_position)
	chunk_map[chunk_position.y][chunk_position.x] = chunk

func save_chunk(coordinates : Vector2i):
	var chunk = chunk_map[coordinates.y][coordinates.x]

	if !chunk:
		print("No chunk at ", coordinates, ". Couldn't save.")
		return

	# Ensure all scripts are embedded or paths are correct
	for node in chunk.get_children(true):
		set_recursive_owner(node, chunk)

	var save_file = PackedScene.new()
	var status = save_file.pack(chunk)

	if status != OK:
		print("Failed to pack scene with error code: ", status)
		return

	var path = get_chunk_path(coordinates)
	status = ResourceSaver.save(save_file, path)
	
	if status != OK:
		print("Failed to save scene: ", path)
		return
		
func set_recursive_owner(node: Node, owner: Node):
	# Set the owner of the current node
	node.owner = owner

	# Recursively set the owner for all children
	for child in node.get_children(true):
		set_recursive_owner(child, owner)
func load_from_file_if_exists(coordinates : Vector2i):
	var chunk_file : PackedScene
	var path = get_chunk_path(coordinates)
	print(path)
	if FileAccess.file_exists(path):
		var loaded_scene = load(path) as PackedScene
		
		if !loaded_scene:
			print("Failed to load chunk at ", coordinates)
			return null
		
		return loaded_scene

func print_chunk_children(chunk):
	if chunk:
		print("Chunk instantiated successfully.")
		print("Children of chunk: ", chunk.get_child_count())
		for child in chunk.get_children():
			print("Child: ", child.name, " - Class: ", child.get_class())
			for child2 in child.get_children():
				print("		Child: ", child2.name, " - Class: ", child2.get_class())
				for child3 in child2.get_children():
					print("			Child: ", child3.name, " - Class: ", child3.get_class())
					
func get_chunk_path(coordinates: Vector2i) -> String:
	return "user://chunks/chunk_%d_%d.tscn" % [coordinates.x, coordinates.y]
