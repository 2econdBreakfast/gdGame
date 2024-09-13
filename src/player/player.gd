class_name Player extends CharacterBody2D

#members
var facing_dir : Vector2

@export var sprite : AnimatedSprite2D
@export var input_listener : PlayerInputListener
@export var state_machine : PlayerStateMachine
@export var inventory : Inventory


func _ready():
	self.facing_dir = Direction.SOUTH
	if inventory:
		$ItemDetector.inventory = inventory
	
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
