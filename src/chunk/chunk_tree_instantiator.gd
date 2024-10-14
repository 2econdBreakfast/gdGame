# ChunkTreeInstantiator.gd

class_name ChunkTreeInstantiator extends Node

@export var tree_prototypes: Array[PackedScene]
var debug: bool = false

func instantiate(chunk: Chunk, chunk_position: Vector2i, chunk_size: Vector2):
	if tree_prototypes.size() == 0:
		print("TreeInstantiator: no prototypes found!")
		return
		
	if debug:
		print("Chunk objects: ", chunk.object_data.size())

	for object in chunk.object_data:
		if object is TreeData:
			var tree: Node2D = tree_prototypes[object.tree_type - 1].instantiate()
			if !tree:
				print("Couldn't instantiate tree")
				continue
			tree.data = object
			tree.global_position = calculate_tree_position(object.position)
			chunk.call_deferred("add_child", tree)

func calculate_tree_position(tree_grid_position: Vector2i) -> Vector2:
	return Vector2(tree_grid_position) * Vector2(WORLD_DATA.terrain_tilemap.tile_set.tile_size) + Vector2(randi_range(-32, 32), randi_range(-32, 32))
