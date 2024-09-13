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
	Globals.TileCoords.FOREST_GRASS,
	[
		Globals.TreeID.PINE,
		Globals.TreeID.DEAD
	],
	0.7
)

static var PLAINS : BiomeData = BiomeData.new(
	Globals.Biome.PLAINS,
	"Forest",
	Globals.TileCoords.GRASS,
	[
		Globals.TreeID.OAK
	],
	0.05
)

static var BEACH : BiomeData = BiomeData.new(
	Globals.Biome.BEACH,
	"Forest",
	Globals.TileCoords.SAND,
	[
		Globals.TreeID.PALM
	],
	0.1
)

static var OCEAN : BiomeData = BiomeData.new(
	Globals.Biome.OCEAN,
	"Ocean",
	Globals.TileCoords.WATER,
	[],
	0.0
)

