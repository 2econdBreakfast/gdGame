@tool
class_name DebugInputListener extends Node

@export var enabled : bool:
	set(v):
		if v:
			self.set_process_input(true)
			print("Debug Input Enabled")
		else:
			self.set_process_input(false)
			print("Debug Input Disabled")

func _unhandled_input(event):
	if Input.is_action_pressed("dbg_decrease_health"):
		CHARACTER_DATA.change_health(-1)
		print(CHARACTER_DATA.cur_health)
	if Input.is_action_pressed("dbg_increase_health"):
		CHARACTER_DATA.change_health(1)
		print(CHARACTER_DATA.cur_health)
