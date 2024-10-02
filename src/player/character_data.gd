class_name CharacterData extends Node

signal money_changed
signal health_changed
signal health_at_zero

var _max_health : int
var max_health : int:
	set(v):
		_max_health = max(v, 0)
		
		# update cur_health in case it needs to be clamped
		cur_health = cur_health
		
		health_changed.emit()
	get:
		return _max_health

var _cur_health : int
var cur_health : int:
	set(v):
		_cur_health = clamp(v, 0, max_health)
		health_changed.emit()
		if _cur_health == 0:
			health_at_zero.emit()
	get:
		return _cur_health

var _cur_money : int
var cur_money : int:
	set(v):
		_cur_money = v
		money_changed.emit()
	get:
		return _cur_money


func _ready():
	max_health = 100
	cur_health = 100
	cur_money = 100

func add_money(amount : int):
	self.cur_money += amount

func change_health(amount : int):
	self.cur_health += amount

func change_max_health(amount : int):
	self.max_health += amount
