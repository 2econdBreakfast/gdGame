class_name ChunkFileAccess

static func save_chunk(chunk: Node, coordinates: Vector2i):
	var path = get_chunk_path(coordinates)
	
	# Ensure all scripts are embedded or paths are correct
	for node in chunk.get_children(true):
		set_recursive_owner(node, chunk)
	
	var save_file = PackedScene.new()
	var status = save_file.pack(chunk)
	
	if status != OK:
		print("Failed to pack scene with error code: ", status)
		return
	
	var error = ResourceSaver.save(save_file, path)
	if error != OK:
		print("Failed to save scene: ", path, " Error code: ", error)

static func load_chunk(coordinates: Vector2i) -> Node:
	var path = get_chunk_path(coordinates)
	if ResourceLoader.exists(path):
		var packed_scene = load(path) as PackedScene
		if packed_scene:
			var chunk = packed_scene.instantiate()
			return chunk
		else:
			print("Failed to load PackedScene at ", path)
	else:
		print("No saved chunk at ", path)
	return null

static func get_chunk_path(coordinates: Vector2i) -> String:
	return "user://chunks/chunk_%d_%d.tscn" % [coordinates.x, coordinates.y]

static func set_recursive_owner(node: Node, owner: Node):
	# Set the owner of the current node
	node.owner = owner
	
	# Recursively set the owner for all children
	for child in node.get_children():
		set_recursive_owner(child, owner)

static func clear_chunk_directory(chunk_path: String):
	if DirAccess.dir_exists_absolute(chunk_path):
		var dir = DirAccess.open(chunk_path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if !dir.current_is_dir():
					var file_path = chunk_path + "/" + file_name
					DirAccess.remove_absolute(file_path)
				file_name = dir.get_next()
			dir.list_dir_end()
	else:
		DirAccess.make_dir_recursive_absolute(chunk_path)
