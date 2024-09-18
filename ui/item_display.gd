class_name ItemDisplay extends TextureRect

var item_data : ItemData:
	set(v):
		_item_data = v
		if _item_data:
			texture = _item_data.spriteTexture
			visible = true
		else:
			texture = null
			visible = false
	get:
		return _item_data
		
var _item_data : ItemData

var count : int:
	set(v):
		if _count < 0:
			count = 0
		else:
			$ItemCount.text = var_to_str(v)
			_count = v
			if _count == 0:
				item_data = null
		
	get: 
		return _count
		
var grabbed : bool

func _process(delta):
	if grabbed:
		self.global_position = get_global_mouse_position()
	else: 
		self.global_position = get_parent().global_position
		
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				grabbed = true
			else:
				print("about to release")
				grabbed = false
				print("releasing")
		
var _count : int 


