class_name TileInteractionManager extends Node

var target_tile
var is_valid_tile_cached : bool
var tile_validation_callback

var _interaction_enabled
var interaction_enabled : bool:
	set(v):
		_interaction_enabled = v
		if v:
			self.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			self.process_mode = Node.PROCESS_MODE_DISABLED
			
	get: return _interaction_enabled

func _ready():
	self.process_mode = Node.PROCESS_MODE_DISABLED
func _process(delta):
	
	var new_target = Player.instance.get_tile_directly_ahead()
	
	var is_valid_tile = tile_validation_callback.call()
	
	if new_target != target_tile or is_valid_tile != is_valid_tile_cached:
		target_tile = new_target
		is_valid_tile_cached = is_valid_tile
		TILE_HIGHLIGHTER.clear_highlighted()
		TILE_HIGHLIGHTER.highlight(target_tile, is_valid_tile)
		
	
func enable_interaction_mode(tile_validation_callback : Callable):
	if not tile_validation_callback:
		return
	
	self.tile_validation_callback = tile_validation_callback
	self.interaction_enabled = true
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func disable_interaction_mode():
	if not tile_validation_callback:
		return
	
	TILE_HIGHLIGHTER.clear_highlighted()
	self.target_tile = null
	self.tile_validation_callback = null
	self.interaction_enabled = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
