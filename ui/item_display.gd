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

var grabbed : bool : 
	set(v):
		_grabbed = v
		if _grabbed:
			self.self_modulate.a = 0.5
		else:
			self.self_modulate.a = 1
	get:
		return _grabbed 

var _grabbed : bool

var _count : int 
