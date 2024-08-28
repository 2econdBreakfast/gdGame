extends Node
class_name PerlinWorm

class PathVertex:
	var m_position : Vector2i
	var m_speed : int
	var m_direction : Vector2
	
	func _init(position, speed, direction):
		self.m_position = position
		self.m_speed = speed
		self.m_direction = direction


var m_max_speed : int = 3
var m_max_turn_angle : float = 180
var m_slowdown_angle_threshold : int = 15
var m_min_dist_from_target_for_success : float = 1


var m_path : Array[Vector2i]

var m_last_direction : Vector2 = Vector2.ZERO
var m_cur_position : Vector2i = Vector2i.ZERO
var m_cur_direction : Vector2 = Vector2.ZERO
var m_cur_speed : int = 1
var m_target_point : Vector2i = Vector2i.ZERO
var m_bounds : Vector2i = Vector2i.ZERO


# direction calculation params
var m_noise_weight : float = 0.3
var m_cur_direction_weight : float = 0.3
var m_target_direction_weight : float = 0.4

var _m_noise : FastNoiseLite

var m_start : Vector2i

signal finished(worm : PerlinWorm)


func _init(noise_noise_seed : int = -1):
	var settings = NoiseSettings2D.new()
	settings.type = FastNoiseLite.TYPE_CELLULAR
	settings.freq = 0.005
	if noise_noise_seed == -1:
		settings.randomnoise_seed = true
	else:
		settings.randomnoise_seed = false
		settings.noise_seed = noise_noise_seed
	self._m_noise =  Noise2D.get_noise(settings)


func initialize_path(start : Vector2i, target : Vector2i, start_dir : Vector2i):
	if not VectorTools.a_inside_b(start, self.m_bounds):
		return
	m_start = start
	m_target_point = target
	_m_noise.seed = randi()
	
	self.m_cur_position = m_start
	self.m_target_point = m_target_point
	self.m_cur_direction = start_dir
	update_direction()


# generates full path in one call.
func generate_path(start : Vector2i, target : Vector2i, start_dir : Vector2i = Vector2i.ZERO, clear_old_path : bool = false):
	if clear_old_path:
		m_path = []
		
	initialize_path(start, target, start_dir)



# used each step in generation
func find_next_point():

	# check if near target
	if VectorTools.a_within_range_of_b(self.m_cur_position, m_target_point, m_min_dist_from_target_for_success) \
		or !VectorTools.a_inside_b(self.m_cur_position, self.m_bounds) \
		or self.m_cur_direction.is_equal_approx(Vector2.ZERO):
		finished.emit(self)
	# caches last direction and updates current
	update_direction()
	
	update_speed()
	
	# Calculate next position
	var displacement = VectorTools.calc_displacement_rounded(m_cur_speed, m_cur_direction)
	var next_pos = self.m_cur_position + displacement
	
	for i in range(m_cur_speed):
		m_path.append(m_cur_position + VectorTools.calc_displacement_rounded(i, m_cur_direction))
	
	self.m_cur_position = next_pos


func clear_path():
	m_path = []


func update_direction():
	self.m_last_direction = self.m_cur_direction
	
	var noise_value = _m_noise.get_noise_2dv(self.m_cur_position)
	
	var noise_direction = NoiseTools.noise_val_to_dir(noise_value, m_max_turn_angle)
	var target_direction = Vector2(m_target_point - m_cur_position).normalized()
	
	var direction_dict = {
		noise_direction : self.m_noise_weight,
		self.m_cur_direction : self.m_cur_direction_weight,
		target_direction : self.m_target_direction_weight
	}
	
	var new_dir = interpolate_directions_weighted(direction_dict)
	var new_angle = new_dir.angle_to(m_cur_direction)
	if abs(rad_to_deg(new_angle)) > m_max_turn_angle:
		new_angle = sign(new_angle) * deg_to_rad(m_max_turn_angle)
		var dx = cos(new_angle)
		var dy = sin(new_angle)
		new_dir = Vector2(dx, dy)
	self.m_cur_direction = new_dir


func update_speed():
	# Calculate the difference between last direction and current direction
	var direction_diff = rad_to_deg(m_last_direction.angle_to( self.m_cur_direction))
	
	# Adjust speed based on direction difference
	self.m_cur_speed = calculate_new_speed(self.m_cur_speed, direction_diff)


# Function to calculate speed based on direction difference
func calculate_new_speed(speed, direction_diff):
	var delta_speed = 1
	if abs(direction_diff) > m_slowdown_angle_threshold:
		delta_speed = -1
	return clampi(speed + delta_speed, 1, m_max_speed)


func interpolate_directions_weighted(weighted_direction_dict : Dictionary) -> Vector2:
	
	var summed_direction : Vector2 = Vector2.ZERO
	
	for dir in weighted_direction_dict.keys():
		var weight = weighted_direction_dict[dir]
		summed_direction += (dir * weight)
	
	var new_direction = summed_direction.normalized()
	
	return new_direction


func set_noise_seed(noise_noise_seed : int):
	_m_noise.noise_seed = noise_noise_seed


func set_noise_type(noise_type : FastNoiseLite.NoiseType):
	_m_noise.noise_type = noise_type


func set_freq(freq : float):
	_m_noise.frequency = freq


func print_debug_info():
	print("Position: ", m_cur_position)
	print("Direction: ", m_cur_direction)
	print("Size: ", m_path.size())
	print("Target: ", m_target_point)
	print("Target Range: ", m_min_dist_from_target_for_success)
	print("Distance from Target: ", (m_target_point - m_cur_position).length())


# ====================================   HELPERS   ====================================

func distance_to_target():
	return Vector2(m_target_point - m_cur_position).length()

func size():
	return m_path.size()
	
func last():
	if size() > 0:
		return m_path.back()

func first():
	if size() > 0:
		return m_path[0]
		
func vertex_at(idx : int):
	return m_path[idx]
