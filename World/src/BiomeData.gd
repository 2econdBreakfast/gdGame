class_name BiomeData

var ID : int
var name : String
var tree_atlas_coords : Array[Vector2i]
var terrain_atlas_coords : Vector2i 

func _init(ID : int, name : String, terrain_atlas_coords : Vector2i, tree_atlas_coords : Array[Vector2i]):
	self.ID = ID
	self.name = name
	self.terrain_atlas_coords = terrain_atlas_coords
	self.tree_atlas_coords = tree_atlas_coords

func get_random_tree():
	return tree_atlas_coords.pick_random()
