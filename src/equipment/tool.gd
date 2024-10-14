class_name Tool extends Node2D


var active : bool:
	set(v):
		_active = v
		time_since_activated = 0
		if v:
			self.on_activate()
		else:
			self.on_deactivate()
	get: return _active

var _active : bool
var tool_name : String
var player : Player
var time_since_activated : float

# buffer time to ensure that double activation doesn't happen on 
# first press for some equipment
var usage_delay : float = 0.03
signal done()

func _init(player : Player):
	self.player = player

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		TILE_HIGHLIGHTER.clear_highlighted()
		self.active = false
		return
	if not usage_delay_finished():
		time_since_activated += delta
		
func usage_delay_finished():
	return time_since_activated >= usage_delay
func use():
	pass

func can_use():
	pass
	
func on_activate():
	pass
	
func on_deactivate():
	pass
