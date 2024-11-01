class_name DebugHungerMeter extends Node

var hunger_change_freq = 0.02
var cur_time = 0.0
var satiation_change_amount = 1
func _process(delta):
	cur_time += delta
	if cur_time > hunger_change_freq:
		CHARACTER_DATA.satiation += satiation_change_amount
		if CHARACTER_DATA.satiation <= 0:
			CHARACTER_DATA.satiation = 0
			satiation_change_amount = 1
		elif CHARACTER_DATA.satiation >= 100:
			CHARACTER_DATA.satiation = 100
			satiation_change_amount = -1
		cur_time = 0.0
		
