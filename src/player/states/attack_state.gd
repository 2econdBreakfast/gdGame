class_name AttackState extends State

var attack_timer = 10
var cur_attack_time = 0
var damage = 10
@export var hitboxes : Array[Area2D]

func init_state(player : Player):
	self._player = player

func enter():
	_player.prepare_to_attack()
	cur_attack_time = 0
	_player.sprite.pause()
	for hitbox in hitboxes:
		hitbox.area_entered.connect(on_hitbox_area_entered)
		hitbox.get_node("CollisionShape2D").debug_color.a = 0.2
		hitbox.monitoring = true

func exit():
	for hitbox in hitboxes:
		hitbox.area_entered.disconnect(on_hitbox_area_entered)
		hitbox.get_node("CollisionShape2D").debug_color.a = 0 
		hitbox.monitoring = false

func on_hitbox_area_entered(area):
	var parent = area.get_parent()
	if parent.has_method("on_hit"):
		parent.on_hit(1)

func process_input() -> State:
	if cur_attack_time < attack_timer:
		cur_attack_time += 1
		return self
	else:
		return _player.state_machine.states["idle"].process_input()
