extends Camera2D

func _ready():
	set_camera_limits()

func set_camera_limits():
	var w = WORLD_DATA.map_size.x
	var h = WORLD_DATA.map_size.y
	var map_limits = Vector2i(w, WORLD_DATA.cache.get("height"))
	var tile_size = WORLD_DATA.terrain_tilemap.tile_set.tile_size
	self.limit_left = 0
	self.limit_right = map_limits.x * tile_size.x
	self.limit_top = 0
	self.limit_bottom = map_limits.y * tile_size.y

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("zoom_out"):
		self.zoom /= 1.3
	elif Input.is_action_just_pressed("zoom_in"):
		self.zoom *= 1.3
