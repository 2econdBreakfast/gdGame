class_name BiomeData

var ID : int
var name : String
var tree_types : Array[int]
var terrain_atlas_coords : Vector2i 
var fertility

func _init(ID : int, name : String, terrain_atlas_coords : Vector2i, tree_types : Array[int], fertility : float):
	self.ID = ID
	self.name = name
	self.terrain_atlas_coords = terrain_atlas_coords
	self.tree_types = tree_types
	self.fertility = fertility

func get_random_tree():
	if tree_types.size() == 0: return null
	return tree_types.pick_random()
