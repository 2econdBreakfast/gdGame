class_name CharacterData extends Node

signal money_changed
signal health_changed
signal health_at_zero
signal satiation_changed

var is_new_character : bool = true

var _max_health : int
var max_health : int:
	set(v):
		_max_health = max(v, 0)
		# update health in case it needs to be clamped
		# also emits health changed signal
		health = health
	get:
		return _max_health

var _health : int
var health : int:
	set(v):
		_health = clamp(v, 0, max_health)
		health_changed.emit()
		if _health == 0:
			health_at_zero.emit()
	get: return _health

var _money : int
var money : int:
	set(v): _money = v; money_changed.emit();
	get: return _money


var _satiation : float
var satiation : float:
	set(v):
		_satiation = v
		satiation_changed.emit()
	get:
		return _satiation
		
var _max_satiation : float
var max_satiation : float:
	set(v):
		_max_satiation = v
		satiation_changed.emit()
	get:
		return _max_satiation

enum HealType {
	AMOUNT,
	PERCENT_OF_MAX,
	FULL
}

func _ready():
	if (is_new_character):
		max_health = 100
		health = 100
		money = 100
		max_satiation = 100
		satiation = 100
		is_new_character = false

func add_money(amount : int):
	self.money += amount

func heal(amount : int, heal_type : HealType = HealType.AMOUNT):
	match(heal_type):
		HealType.AMOUNT:
			self.health += amount
		HealType.PERCENT_OF_MAX:
			self.health += int(self.max_health * float(amount) / float(max_health))


func heal_to_max(amount : int):
	self.health = self.max_health
