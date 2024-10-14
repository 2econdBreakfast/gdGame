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
	if Input.is_action_just_pressed("use_tool"):
		return state_machine.states.get("use_tool")
	if Input.is_action_just_pressed("attack"):
		return state_machine.states.get("attack")
	if _player.get_cardinal_direction_name() != direction_name:
		direction_name = _player.get_cardinal_direction_name()
		_player.play_animation(animation_name + direction_name)
	if _player.input_listener.dirInput.is_equal_approx(Vector2.ZERO):
		return state_machine.states.get("idle");
	elif _player.input_listener.runPressed:
		return state_machine.states.get("run")
	else:
		return state_machine.states.get("walk") 


func process_physics(delta):
	_player.move(move_speed * _player.input_listener.dirInput.normalized() * delta)
