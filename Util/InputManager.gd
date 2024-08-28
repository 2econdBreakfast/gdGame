extends Node2D

var mapGenerator : MapGenerator
func _ready():
	mapGenerator = get_node("../MapGenerator")
# Called every frame. 'delta' is the elapsed time since the previous frame.
