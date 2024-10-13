class_name TreeData extends WorldObjectData

var tree_type : int
var age : int
var health : int

func _init(tree_type : int, age : int, position : Vector2):
	self.tree_type = tree_type
	self.age = age
	super._init(position)
