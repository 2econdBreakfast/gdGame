# ChunkMemoryAccess.gd

class_name ChunkMemoryAccess

static var chunk_data_map = {}  # Dictionary to hold chunk data in memory

static func save_chunk(chunk: Chunk, coordinates: Vector2i):
	# Prepare data to be saved
	var chunk_data = {
		"map_data": chunk.map_data,
		"object_data": serialize_object_data(chunk.object_data)
	}
	# Store in the in-memory dictionary
	var key = "%d_%d" % [coordinates.x, coordinates.y]
	chunk_data_map[key] = chunk_data

static func load_chunk(coordinates: Vector2i) -> Chunk:
	var key = "%d_%d" % [coordinates.x, coordinates.y]
	if chunk_data_map.has(key):
		var chunk_data = chunk_data_map[key]
		
		var chunk_size = chunk_data["map_data"].size()
		var chunk = Chunk.new()
		chunk.initialize(chunk_size)
		chunk.map_data = chunk_data["map_data"]
		chunk.object_data = deserialize_object_data(chunk_data["object_data"])
		
		return chunk
	else:
		print("No saved chunk at ", coordinates)
	return null

static func serialize_object_data(object_data_array: Array) -> Array:
	var serialized_array = []
	for obj in object_data_array:
		if obj is TreeData:
			var data = {
				"type": "TreeData",
				"tree_type": obj.tree_type,
				"age": obj.age,
				"health": obj.health,
				"position": obj.position
			}
			serialized_array.append(data)
		else:
			# Handle other types of WorldObjectData if any
			pass
	return serialized_array

static func deserialize_object_data(serialized_array: Array) -> Array:
	var object_data_array = []
	for data in serialized_array:
		if data["type"] == "TreeData":
			var tree_data = TreeData.new(data["tree_type"], data["age"], data["position"])
			tree_data.health = data["health"]
			object_data_array.append(tree_data)
		else:
			# Handle other types of WorldObjectData if any
			pass
	return object_data_array
