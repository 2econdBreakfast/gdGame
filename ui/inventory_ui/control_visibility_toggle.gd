class_name ControlVisibilityToggle extends Node
var _target : Control
@export var target : Control:
	get: return _target
	set(v):
		_target = v
		if _target:
			_control_default_process_mode = \
				_target.process_mode if _target.process_mode == PROCESS_MODE_DISABLED \
				else PROCESS_MODE_ALWAYS
@export var disable_process_when_hidden : bool
@export var auto_hide_on_ready : bool
@export var _input_action_name : String
var _control_default_process_mode : ProcessMode

var showing : bool:
	get: return target.visible if target else false

signal visibility_toggled(visible : bool)

func _ready():
	if target == null:  # Replace with your condition
		push_warning("No target set in inspector.")
	if not _input_action_name or _input_action_name.length() == 0:
		push_warning("No input action name set in inspector.")
	if InputMap.has_action(StringName(_input_action_name)):
		push_warning("input action \'%s\' not found in input map" % _input_action_name)

	if target:
		if auto_hide_on_ready:
			_hide_target()
		_control_default_process_mode = target.process_mode

func _unhandled_input(event):
	if _input_action_name:
		if Input.is_action_just_pressed(_input_action_name):
			_toggle_visibility()
			
func _toggle_visibility():
	if target:
		if target.visible:
			_hide_target()
		else:
			_show_target()
	visibility_toggled.emit(target.visible)
			
func _show_target():
	target.visible = true
	_update_target_process_mode()
	
func _hide_target():
	target.visible = false
	_update_target_process_mode()
	
func _update_target_process_mode():
	if target:
		if disable_process_when_hidden and !showing:
			target.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			target.process_mode = _control_default_process_mode
