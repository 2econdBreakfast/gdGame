class_name GameClock extends Node

# Singleton instance managed via autoload
# No need to manually handle the static singleton instance
# You can access this globally via GameClock if autoloaded

var date_time : TimeOfDay
var total_game_days : int = 0


# always set time scale this way, so we can keep it as an int
var GAME_TIME_SCALE : int:
	get:
		return round(Engine.time_scale)
	set(v):
		Engine.time_scale = v

const GAME_MINUTES_PER_TIMER_UPDATE : int = 5
const TIMER_UPDATE_INTERVAL : int = 5

@onready var timer : Timer = Timer.new()

signal date_time_changed
signal initialized

func _ready():
	if date_time == null:
		date_time = TimeOfDay.new(0, 6, 0)
	timer.one_shot = false
	timer.timeout.connect(on_game_minute_timer_timeout)
	timer.wait_time = TIMER_UPDATE_INTERVAL
	call_deferred("add_child", timer)
	timer.ready.connect(timer.start)

func _unhandled_input(event):
	if Input.is_action_pressed("debug_increment_time"):
		pass_time(1, 0, 0)
		print(time_str())

func pass_time(game_minutes : int = 0, game_hours : int = 0, game_days : int = 0):
	for i in range(game_minutes + game_hours * 60 + game_days * 24 * 60):
		increment_minute()

func on_game_minute_timer_timeout():
	# one minute has passed in real life, increment that many minutes mult. by engine time scale
	var minutes_to_pass : int = GAME_TIME_SCALE * GAME_MINUTES_PER_TIMER_UPDATE
	for i in range(minutes_to_pass):
		increment_minute()

func increment_minute():
	date_time.minute = date_time.minute + 1
	emit_signal("date_time_changed")
	if date_time.minute == 60:
		date_time.minute = 0
		increment_hour()

func increment_hour():
	date_time.hour = date_time.hour + 1
	emit_signal("date_time_changed")
	if date_time.hour == 24:
		date_time.hour = 0
		increment_day()

func increment_day():
	date_time.weekday = (date_time.weekday + 1) % 7
	total_game_days += 1
	emit_signal("date_time_changed")

func time_str():
	return "%02d:%02d" % [date_time.hour, date_time.minute]

func day_str():
	match date_time.weekday:
		TimeOfDay.WeekDay.SUNDAY:		return "Sunday"
		TimeOfDay.WeekDay.MONDAY:		return "Monday"
		TimeOfDay.WeekDay.TUESDAY:		return "Tuesday"
		TimeOfDay.WeekDay.WEDNESDAY:	return "Wednesday"
		TimeOfDay.WeekDay.THURSDAY:		return "Thursday"
		TimeOfDay.WeekDay.FRIDAY:		return "Friday"
		TimeOfDay.WeekDay.SATURDAY:		return "Saturday"
