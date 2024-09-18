class_name Chunk extends Node2D
var map_data : Array[Array] = []
var object_data : Dictionary = {}

func _init(size):
	map_data.resize(size)
	for row in map_data:
		row.resize(size)
	self.y_sort_enabled = true

func add_object(obj: PackedScene, pos: Vector2):
	var instance = obj.instance()
	instance.position = pos
	add_child(instance)

