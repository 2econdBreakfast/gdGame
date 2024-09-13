class_name DestructibleObject extends Node2D

@export var health : int

signal destroyed

# flag to make sure that destruction signal only sent once
var destruction_signal_sent : bool = false

func on_hit(damage_amount : int):
	self.health = max(self.health - damage_amount, 0)
	print("hit")
	if health == 0:
		destroy_self()

func destroy_self():
	if destroyed and !destruction_signal_sent:
		destroyed.emit()
		destruction_signal_sent = true
		call_deferred("queue_free")
