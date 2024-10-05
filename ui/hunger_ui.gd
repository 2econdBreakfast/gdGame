class_name HungerUI extends HSplitContainer


@onready var icon_aspect_container : AspectRatioContainer = $AspectRatioContainer
@onready var percentage_label : Label = $HungerPercentage
@onready var hunger_icon : TextureProgressBar = $AspectRatioContainer/HungerIcon
@onready var ICON_BASE_SIZE : Vector2 = $AspectRatioContainer/HungerIcon.custom_minimum_size
@onready var LABEL_BASE_SIZE : Vector2 = $HungerPercentage.size
@onready var LABEL_BASE_FONT_SIZE : int = $HungerPercentage.label_settings.font_size
# Called when the node enters the scene tree for the first time.

@export var scale_multiplier : float:
	set(v):
		_scale_multiplier = v
		_update_scale()
	get:
		return _scale_multiplier
	
var _scale_multiplier : float

func _ready():
	_update_hunger_percentage_label()
	_update_scale()
	CHARACTER_DATA.satiation_changed.connect(_update_hunger_percentage_label)

func _on_money_changed():
	_update_hunger_percentage_label()

func _update_hunger_percentage_label():
	var current_satiation_percentage : int = ((CHARACTER_DATA.satiation / CHARACTER_DATA.max_satiation) * 100)
	percentage_label.text = "%d%%" % current_satiation_percentage
	hunger_icon.value = current_satiation_percentage

func _update_scale():
	self.split_offset = (ICON_BASE_SIZE.x + 13) * _scale_multiplier 
	if percentage_label:
		percentage_label.custom_minimum_size = LABEL_BASE_SIZE * _scale_multiplier
		percentage_label.label_settings.font_size = LABEL_BASE_FONT_SIZE * _scale_multiplier
		percentage_label.position.y = (hunger_icon.size.y - percentage_label.size.y) / 2
	if icon_aspect_container:
		icon_aspect_container.custom_minimum_size = ICON_BASE_SIZE * _scale_multiplier
