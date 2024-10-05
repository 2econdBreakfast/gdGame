class_name HUDMarginController extends MarginContainer

@export_range(0, 100) var margin_percentage : float
func _ready():
	get_viewport().size_changed.connect(update_margins)
	update_margins()

func update_margins():
	var hud_margin = get_viewport_rect().size * (margin_percentage / 100)
	set_margin(hud_margin)
	print(hud_margin)
	
func set_margin(value : Vector2):
	add_theme_constant_override("margin_top", value.y)
	add_theme_constant_override("margin_left", value.x)
	add_theme_constant_override("margin_bottom", value.y)
	add_theme_constant_override("margin_right", value.x)
