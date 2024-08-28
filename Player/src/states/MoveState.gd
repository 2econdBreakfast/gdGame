class_name WalkState extends State

var move_speed : float = 300

var direction_name : String

const animation_name : String = "walk_"

func enter():
	super.enter()
	var animation_direction = _player.get_cardinal_direction_name()
	self._player.play_animation(animation_name + animation_direction)
	
func exit():
	pass

func process_input() -> State:
	
	if _player.input_listener.dirInput.is_equal_approx(Vector2.ZERO):
		return state_machine.states.get("idle");
	else:
		if _player.get_cardinal_direction_name() != direction_name:
			direction_name = _player.get_cardinal_direction_name()
			_player.play_animation(animation_name + direction_name)
		return self

func process_physics(delta):
	_player.move(move_speed * _player.input_listener.dirInput.normalized() * delta)
