class_name ConsumableItemData extends ItemData

var _active : bool
var active : bool:
	set(v):
		_active = v
		if _active:
			self.on_activate()
		else:
			self.on_deactivate()

func can_use():
	return false

func use():
	pass

func on_activate():
	pass

func on_deactivate():
	pass
