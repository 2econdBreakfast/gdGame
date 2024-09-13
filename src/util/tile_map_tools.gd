class_name TileMapTools

static func get_layer_id_from_name(tilemap : TileMap, layer_name : String):
	for i in range(tilemap.get_layers_count()):
		if tilemap.get_layer_name(i) == layer_name:
			return i
	return -1
