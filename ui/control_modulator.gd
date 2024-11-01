class_name ControlModulator extends Node


@export var target: Control  # The sprite to modulate
@export var target_alpha: float = 1.0  # Desired alpha value (0.0 to 1.0)
@export var fade_time: float = 0.1  # Speed of alpha change per second

var _is_modulating: bool = false  # Track if modulation is active

func _ready() -> void:
	# Ensure the process_frame signal is disconnected initially
	if get_tree().is_connected("process_frame", self._on_process_frame):
		get_tree().disconnect("process_frame", self._on_process_frame)

func start_modulation(new_alpha: float) -> void:
	target_alpha = clamp(new_alpha, 0.0, 1.0)  # Clamp target alpha to valid range
	if not _is_modulating:
		_is_modulating = true
		# Connect the signal to our callback
		get_tree().connect("process_frame", self._on_process_frame)

func _on_process_frame() -> void:
	# Get the delta time for smooth transitions
	var delta = get_process_delta_time()

	# Get the current alpha value
	var current_alpha = target.modulate.a

	# Calculate the step size based on modulation speed and delta time
	var step = (target_alpha / fade_time) * delta

	if abs(current_alpha - target_alpha) <= step:
		# Set to target alpha and stop modulation if close enough
		target.modulate.a = target_alpha
		stop_modulation()
	else:
		# Interpolate towards the target alpha value
		target.modulate.a = lerp(current_alpha, target_alpha, step)

func stop_modulation() -> void:
	if _is_modulating:
		_is_modulating = false
		# Disconnect the process_frame signal
		get_tree().disconnect("process_frame", self._on_process_frame)
