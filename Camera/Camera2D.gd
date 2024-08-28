extends Camera2D

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("zoom_out"):
		self.zoom /= 1.3	
	elif Input.is_action_just_pressed("zoom_in"):
		self.zoom *= 1.3
