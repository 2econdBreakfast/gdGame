class_name MoneyUI extends HSplitContainer

@onready var amount_label : Label = $MoneyAmount
@onready var coin_icon : TextureRect = $CoinIcon
@onready var COIN_ICON_BASE_SIZE : Vector2 = $CoinIcon.custom_minimum_size
@onready var MONEY_AMOUNT_LABEL_BASE_SIZE : Vector2 = $MoneyAmount.size
@onready var LABEL_BASE_FONT_SIZE : int = $MoneyAmount.label_settings.font_size
# Called when the node enters the scene tree for the first time.

@export var scale_multiplier : float:
	set(v):
		_scale_multiplier = v
		_update_scale()
	get:
		return _scale_multiplier
	
var _scale_multiplier : float

func _ready():
	_update_money_amount_label()
	_update_scale()
	self.visibility_changed.connect(_update_money_amount_label)

func _on_money_changed():
	_update_money_amount_label()
	
func _update_money_amount_label():
	amount_label.text = str(CHARACTER_DATA.cur_money)

func _update_scale():
	if amount_label:
		amount_label.custom_minimum_size = COIN_ICON_BASE_SIZE * _scale_multiplier
		amount_label.label_settings.font_size = LABEL_BASE_FONT_SIZE * _scale_multiplier
		amount_label.position.y = (coin_icon.size.y - amount_label.size.y) / 2
	if coin_icon:
		coin_icon.size = MONEY_AMOUNT_LABEL_BASE_SIZE * _scale_multiplier
