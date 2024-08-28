class_name PlayerInputListener extends Node

var dirInput : Vector2

func _ready():
	pass

func pollInput():
	var new_dirInput = Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		(Input.get_action_strength("walk_up") - Input.get_action_strength("walk_down")) * - 1
	)
	if new_dirInput != dirInput:
		self.dirInput = new_dirInput
