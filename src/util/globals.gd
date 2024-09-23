class_name Globals

static var THREAD_DICTIONARY : Dictionary = {}

class TerrainTileType:
	const DEEP_WATER		= Vector2i(0, 0)
	const WATER				= Vector2i(1, 0)
	const GRASS				= Vector2i(2, 0)
	const FOREST_GRASS		= Vector2i(3, 0)
	const SAND				= Vector2i(4, 0)
	const SOIL				= Vector2i(5, 0)
	const RICH_SOIL			= Vector2i(6, 0)
	const BUILDING			= Vector2i(-1, -1)

class Biome:
	const FOREST = 0
	const PLAINS = 1
	const BEACH = 2
	const OCEAN = 3
	
class TreeAtlasCoords:
	const OAK				= Vector2i(0, 0)
	const PINE				= Vector2i(1, 0)
	const DEAD				= Vector2i(2, 0)
	const PALM				= Vector2i(3, 0)

class TreeID:
	const OAK				= 1
	const PINE				= 2
	const DEAD				= 3
	const PALM				= 4
class ThreadStatus:
	const RUNNING = 0
	const FINISHED = 1
	const FAILED = 3
	
enum CollisionLayers {
	NAVIGATION_OBSTACLE = 2,
	
}
