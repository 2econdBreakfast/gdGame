class_name FindValidClosePosition extends ActionLeaf

@onready var query_params : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()

func before_run(actor, blackboard: Blackboard):
	query_params.shape = actor.get_node("FloorCollider").shape
	
func tick(actor, blackboard: Blackboard):
	var cur_pos = actor.global_position
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var move_amount = (actor.npc_data.move_range * random_direction)
	var target_pos = cur_pos + move_amount
	if position_is_valid(actor, actor.get_world_2d(), target_pos):
		blackboard.set_value("target_pos", target_pos)
		return SUCCESS
	else:
		return RUNNING

func position_is_valid(actor, world, position):
	return is_position_free(world, position) && can_reach_position(actor, position)

func is_position_free(world, position: Vector2) -> bool:
	var space_state = world.direct_space_state
	query_params.transform = Transform2D(0, position)
	var result = space_state.intersect_shape(query_params, 1)
	return result.is_empty()
	
func can_reach_position(actor , target_position : Vector2) -> bool:
	var param : NavigationPathQueryParameters2D = NavigationPathQueryParameters2D.new() 
	var res : NavigationPathQueryResult2D = NavigationPathQueryResult2D.new()
	var agent : NavigationAgent2D = actor.body_controller.nav_agent
	param.map = agent.get_navigation_map()
	param.target_position = target_position
	param.start_position = actor.global_position
	param.pathfinding_algorithm = NavigationPathQueryParameters2D.PATHFINDING_ALGORITHM_ASTAR
	
	NavigationServer2D.query_path(param, res);
	return res.path.size() > 0
	
