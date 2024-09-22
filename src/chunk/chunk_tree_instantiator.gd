class_name ChunkTreeInstantiator extends Node

@export var tree_prototypes : Array[PackedScene]
@export var tree_tile_size : int = 128
@export var tree_placement_jitter : float
@export var tree_container : Node2D
var TreeIdDictionary : Dictionary = {}

func instantiate(chunk : Chunk, chunk_position : Vector2i, chunk_size : Vector2 ):
	if tree_prototypes.size() == 0:
		print("TreeInstantiator: no prototypes found!")
		return


	for position in chunk.object_data.keys():
		var tree_type = chunk.object_data.get(position)
		if tree_type == 0: continue
		
		var tree : Node2D = tree_prototypes[tree_type - 1].instantiate()
		if !tree:
			print("couldn't instantiate tree")
		tree.global_position = calculate_tree_position(position, chunk_position, chunk_size)
		chunk.call_deferred("add_child", tree)

func calculate_tree_position(tree_grid_position, chunk_position, chunk_size) -> Vector2:
	return Vector2(tree_grid_position) * tree_tile_size + Vector2(randi_range(-32, 32), randi_range(-32, 32)) + Vector2(chunk_position) * chunk_size
