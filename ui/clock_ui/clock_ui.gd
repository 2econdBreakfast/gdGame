extends Control

@onready var time_label : Label = $MarginContainer/HBoxContainer/DateTimeDisplay/Time
@onready var day_label : Label = $MarginContainer/HBoxContainer/DateTimeDisplay/Day
@onready var clock_center : TextureRect = $MarginContainer/HBoxContainer/ClockRim/ClockCenter

const MINUTES_PER_DAY : float = 60.0 * 24.0
const CLOCK_ROTATION_DEGREES_PER_MINUTE : float = 360.0 / MINUTES_PER_DAY

# Called when the node enters the scene tree for the first time.

func _ready():
	if GAME_CLOCK.is_node_ready():
		update_time()
		GAME_CLOCK.date_time_changed.connect(on_time_changed)

func on_time_changed():
	update_time()
	
func update_time():
	time_label.text = GAME_CLOCK.time_str()
	day_label.text = GAME_CLOCK.day_str()
	var minutes_since_midnight = (GAME_CLOCK.date_time.hour * 60) + GAME_CLOCK.date_time.minute
	print("time since midnight: ", minutes_since_midnight)
	clock_center.rotation = deg_to_rad(minutes_since_midnight * CLOCK_ROTATION_DEGREES_PER_MINUTE)
	print("rotation per minute: ", CLOCK_ROTATION_DEGREES_PER_MINUTE)
	print("rotation: ", minutes_since_midnight * CLOCK_ROTATION_DEGREES_PER_MINUTE)

