class_name Biomes

static func get_biome_by_id(id):
	match id:
		Globals.Biome.BEACH: return BEACH
		Globals.Biome.FOREST: return FOREST
		Globals.Biome.PLAINS: return PLAINS
		_: return null


static var FOREST : BiomeData = BiomeData.new(
	Globals.Biome.FOREST,
	"Forest",
	Globals.TerrainTileType.FOREST_GRASS,
	[
		Globals.TreeType.PINE,
		Globals.TreeType.DEAD
	],
	0.7
)

static var PLAINS : BiomeData = BiomeData.new(
	Globals.Biome.PLAINS,
	"Forest",
	Globals.TerrainTileType.GRASS,
	[
		Globals.TreeType.OAK
	],
	0.05
)

static var BEACH : BiomeData = BiomeData.new(
	Globals.Biome.BEACH,
	"Forest",
	Globals.TerrainTileType.SAND,
	[
		Globals.TreeType.PALM
	],
	0.1
)

static var OCEAN : BiomeData = BiomeData.new(
	Globals.Biome.OCEAN,
	"Ocean",
	Globals.TerrainTileType.WATER,
	[],
	0.0
)

