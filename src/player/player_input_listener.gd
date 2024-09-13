class_name PlayerInputListener extends Node

var dirInput : Vector2
var runPressed : bool

func _ready():
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("Run"):
		runPressed = true
	elif Input.is_action_just_released("Run"):
		runPressed = false
func pollInput():
	var new_dirInput = Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		(Input.get_action_strength("walk_up") - Input.get_action_strength("walk_down")) * - 1
	)
	if new_dirInput != dirInput:
		self.dirInput = new_dirInput
