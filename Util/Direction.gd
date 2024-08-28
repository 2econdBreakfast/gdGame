class_name Direction

const CENTER: Vector2        = Vector2(0, 0)
const NORTH : Vector2        = Vector2(0, -1)
const SOUTH : Vector2        = Vector2(0, 1)
const EAST : Vector2         = Vector2(1, 0)
const WEST : Vector2         = Vector2(-1, 0)
const NORTHEAST: Vector2     = Vector2(0.707107, -0.707107)  # Precomputed normalized value for (1, -1)
const SOUTHEAST: Vector2     = Vector2(0.707107, 0.707107)   # Precomputed normalized value for (1, 1)
const NORTHWEST: Vector2     = Vector2(-0.707107, -0.707107) # Precomputed normalized value for (-1, -1)
const SOUTHWEST: Vector2     = Vector2(-0.707107, 0.707107)  # Precomputed normalized value for (-1, 1)

const DIRECTION_NAMES = {
	CENTER      : "center",
	NORTH       : "north",
	SOUTH       : "south",
	EAST        : "east",
	WEST        : "west",
	NORTHEAST   : "northeast",
	SOUTHEAST   : "southeast",
	NORTHWEST   : "northwest",
	SOUTHWEST   : "southwest"
}

static func round_to_cardinal_direction(direction: Vector2) -> Vector2:
	if direction.length() == 0:
		return Direction.SOUTH
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return Direction.EAST
		else:
			return Direction.WEST
	else:
		if direction.y > 0:
			return Direction.SOUTH
		else:
			return Direction.NORTH

static func round_to_eight_directions(direction: Vector2) -> Vector2:
	if direction.length() == 0:
		return Direction.SOUTH
	
	var angle = direction.angle()

	if angle < -3 * PI / 8:  # Between -3/8 PI and -5/8 PI (NW)
		return Direction.NORTHWEST
	elif angle < -PI / 8:  # Between -1/8 PI and -3/8 PI (N)
		return Direction.NORTH
	elif angle < PI / 8:  # Between -1/8 PI and 1/8 PI (NE)
		return Direction.NORTHEAST
	elif angle < 3 * PI / 8:  # Between 1/8 PI and 3/8 PI (E)
		return Direction.EAST
	elif angle < 5 * PI / 8:  # Between 3/8 PI and 5/8 PI (SE)
		return Direction.SOUTHEAST
	elif angle < 7 * PI / 8:  # Between 5/8 PI and 7/8 PI (S)
		return Direction.SOUTH
	elif angle < 9 * PI / 8:  # Between 7/8 PI and 9/8 PI (SW)
		return Direction.SOUTHWEST
	else:  # Between 9/8 PI and -7/8 PI (W)
		return Direction.WEST
