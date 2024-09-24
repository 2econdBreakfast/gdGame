class_name TimeOfDay

enum WeekDay { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }

var weekday : WeekDay
var hour : int
var minute : int

func _init(current_minute : int = 0, current_hour : int = 0, current_weekday : WeekDay = WeekDay.SUNDAY):
	self.hour = current_hour
	self.minute = current_minute
	self.weekday = current_weekday
