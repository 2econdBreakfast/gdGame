# Chunk.gd

class_name Chunk extends Node2D

var map_data: Array = []
var object_data: Array = []

func _init():
	self.y_sort_enabled = true

func initialize(size):
	map_data.resize(size)
	for i in range(size):
		map_data[i] = []
