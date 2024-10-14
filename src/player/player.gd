class_name Player extends CharacterBody2D

#members
var facing_dir : Vector2
var facing_dir_int : Vector2i:
	get:
		var x = 0
		var y = 0
		if facing_dir.x > 0:
			x = 1
		elif facing_dir.x == 0:
			x = 0
		else:
			x = -1
			
		if facing_dir.y > 0:
			y = 1
		elif facing_dir.y == 0:
			y = 0
		else:
			y = -1
			
		return Vector2i(x, y)

@export var sprite : AnimatedSprite2D
@export var input_listener : PlayerInputListener
@export var state_machine : PlayerStateMachine
@export var inventory : Inventory


var equipped_tool : Tool
func _ready():
	self.facing_dir = Direction.SOUTH
	if inventory:
		$ItemDetector.inventory = inventory
	self.equipped_tool = Hoe.new(self)
	self.call_deferred_thread_group("add_child", self.equipped_tool)
	
func _process(delta):
	if input_listener:
		input_listener.pollInput()
	if state_machine:
		state_machine.process_state(delta)

func _physics_process(delta):
	if state_machine:
		state_machine.process_state_physics(delta)

func play_animation(animation_name: String):
	if (sprite):
		sprite.play(animation_name)  # Assuming you have an AnimationPlayer

func move(motion : Vector2) -> KinematicCollision2D:
	self.facing_dir = motion.normalized()
	return move_and_collide(motion)

func stop_moving():
	move_and_collide(Vector2.ZERO)
	
# function to get suffix for 4-direction animations
func get_cardinal_direction_name() -> String:
	return Direction.DIRECTION_NAMES.get(
		Direction.round_to_cardinal_direction(self.facing_dir)
		);

# function to get suffix for 8-direction animations
func get_eight_direction_name() -> String:
	return Direction.DIRECTION_NAMES.get(
		Direction.round_to_eight_directions(self.facing_dir)
		);

func get_current_tile_coordinates():
	if WORLD_DATA.terrain_tilemap:
		return WORLD_DATA.terrain_tilemap.local_to_map(self.global_position - WORLD_DATA.terrain_tilemap.global_position)

func get_tile_at_displacement(displacement : Vector2):
	if WORLD_DATA.terrain_tilemap:
		return WORLD_DATA.terrain_tilemap.local_to_map(self.global_position - WORLD_DATA.terrain_tilemap.global_position) + facing_dir_int

func get_tile_directly_ahead():
	return get_tile_at_displacement(self.facing_dir)

func prepare_to_attack():
	self.equipped_tool.active = false
	
func prepare_to_dash():
	self.equipped_tool.active = false
