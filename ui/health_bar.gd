class_name HealthBar extends HSplitContainer

@onready var health_bar : ProgressBar = $Control/HealthBar
@onready var icon : TextureRect = $HeartIcon
const ICON_BASE_SIZE : Vector2i = Vector2i(32, 32)
const BAR_BASE_Y_SIZE : int = 12

@export var health_bar_scale_multiplier : float:
	set(v):
		_health_bar_scale_multiplier = v
		update_scale()
	get:
		return _health_bar_scale_multiplier
	
var _health_bar_scale_multiplier : float
# Called when the node enters the scene tree for the first time.
func _ready():
	CHARACTER_DATA.health_changed.connect(_on_health_changed)
	_on_health_changed()
	update_scale()
	
func _on_health_changed():
	health_bar.max_value = CHARACTER_DATA.max_health
	health_bar.value = (float(CHARACTER_DATA.health) / float(CHARACTER_DATA.max_health)) * 100.0


func update_scale():
	if health_bar:
		health_bar.size.x = CHARACTER_DATA.max_health * health_bar_scale_multiplier
		health_bar.size.y = BAR_BASE_Y_SIZE * health_bar_scale_multiplier
	if icon:
		icon.custom_minimum_size = ICON_BASE_SIZE * health_bar_scale_multiplier
		# recenter
		icon.position.y = (health_bar.size.y - icon.size.y) / 2
