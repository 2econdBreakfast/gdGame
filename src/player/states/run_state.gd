class_name RunState extends WalkState

func _init():
	self.move_speed = 600

func enter():
	_player.prepare_to_dash()
