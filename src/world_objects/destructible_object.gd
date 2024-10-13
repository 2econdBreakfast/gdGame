class_name DestructibleObject extends WorldObject

@export var health : int

signal destroyed

var destruction_signal_sent : bool = false

func on_hit(damage_amount : int):
	self.health -= damage_amount
	if health <= 0:
		destroy_self()

func destroy_self():
	if !destruction_signal_sent:
		destroyed.emit()
		destruction_signal_sent = true
		call_deferred("queue_free")
