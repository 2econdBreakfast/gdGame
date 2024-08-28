class_name Biomes


static var FOREST : BiomeData = BiomeData.new(
	Globals.Biome.FOREST,
	"Forest",
	Globals.TileCoords.FOREST_GRASS,
	[
		Globals.TreeAtlasCoords.PINE,
		Globals.TreeAtlasCoords.DEAD
	]
)

static var PLAINS : BiomeData = BiomeData.new(
	Globals.Biome.PLAINS,
	"Forest",
	Globals.TileCoords.GRASS,
	[
		Globals.TreeAtlasCoords.OAK
	]
)

static var BEACH : BiomeData = BiomeData.new(
	Globals.Biome.BEACH,
	"Forest",
	Globals.TileCoords.SAND,
	[
		Globals.TreeAtlasCoords.PALM
	]
)
