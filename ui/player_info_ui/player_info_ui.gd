class_name PlayerInfoUI extends VBoxContainer

@onready var health_bar : ProgressBar = $Health/MarginContainer/HealthBar
@onready var money_amount_label = $Money/MoneyAmount
@onready var hunder_percentage_label = $Hunger/HungerPercentage
@onready var hunger_icon = $Hunger/HungerIcon

var signal_callback_dict : Dictionary = {
	CHARACTER_DATA.health_changed : self._on_health_changed,
	CHARACTER_DATA.satiation_changed : self._on_hunger_changed,
	CHARACTER_DATA.money_changed : self._on_money_changed
}
# Called when the node enters the scene tree for the first time.
func _ready():
	self._connect_callbacks()
	self._update_all_values()

func _connect_callbacks():
	for s : Signal in signal_callback_dict.keys():
		s.connect(signal_callback_dict.get(s))

func _update_all_values():
	for c : Callable in signal_callback_dict.values():
		c.call()

func _on_health_changed():
	health_bar.max_value = CHARACTER_DATA.max_health
	health_bar.value = (float(CHARACTER_DATA.health) / float(CHARACTER_DATA.max_health)) * 100.0
	health_bar.custom_minimum_size.x = health_bar.max_value * get_viewport_rect().size.x / 1080
	
	
func _on_money_changed():
	money_amount_label.text = str(CHARACTER_DATA.money)

func _on_hunger_changed():
	var current_satiation_percentage : int = ((CHARACTER_DATA.satiation / CHARACTER_DATA.max_satiation) * 100)
	hunder_percentage_label.text = "%d%%" % current_satiation_percentage
	hunger_icon.value = current_satiation_percentage
