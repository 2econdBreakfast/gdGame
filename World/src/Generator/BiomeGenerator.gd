class_name BiomeGenerator extends GeneratorModule

@onready var delaunay_gen : DelaunayGenerator = DelaunayGenerator.new()

func generate(generation_cache : Dictionary):
	var width = generation_cache["width"]
	var height = generation_cache["height"]
	var rainfall_map = generation_cache["rainfall_map"]
	var heightmap = generation_cache["heightmap"]
	
	self.add_child(delaunay_gen)
	delaunay_gen.generate_sites({"width": 300, "height": 300})
	delaunay_gen.grid_resolution = Vector2i(30, 30)
	var sites = delaunay_gen.sites
	
	var biome_poly_dict : Dictionary = assign_biomes_to_polys(generation_cache, sites)
	var biome_map : Array[Array] = []
	biome_map.resize(height)
	var row : Array = []
	row.resize(width)
	var point : Vector2i = Vector2i.ZERO
	for y in range(height):
		point.y = y
		for x in range(width):
			point.x = x
			for site in biome_poly_dict.keys():
				if Geometry2D.is_point_in_polygon(point, site.polygon):
					row[x] = biome_poly_dict[site]
		biome_map[y] = row.duplicate(true)

	generation_cache["biome_map"] = biome_map
	
func assign_biomes_to_polys(generation_cache : Dictionary, sites) -> Dictionary:
	var rainfall_map = generation_cache["rainfall_map"]
	var heightmap = generation_cache["heightmap"]

	var poly_biome_dict : Dictionary = {}
	var sample_range = 3
	var last_biome = Globals.Biome.WATER
	for site : Delaunay.VoronoiSite in sites:
		var center = site.center
		var tot_sample_height : float = 0
		var tot_sample_rain : float = 0
		var tot_count : float = 0
		var biome = 0
		print(site.center)
		
		for y in range(-sample_range, sample_range):
			if(center.y + y >= 0 and center.y + y < heightmap.size()):
				for x in range(-sample_range, sample_range):
					if(center.x + x >= 0 and center.x + x < heightmap[0].size()):
						tot_count += 1
						tot_sample_rain += rainfall_map[center.y + y][center.x + x]
						tot_sample_height += heightmap[center.y + y][center.x + x]
		if tot_count > 0:
			var avg_sample_height = tot_sample_height / tot_count
			var avg_sample_rain = tot_sample_rain / tot_count
			print("height: ", avg_sample_height)
			print("rain: ", avg_sample_rain)
		
			last_biome = biome
			if avg_sample_height < 0.4:
				biome = Globals.Biome.WATER
			else:
				if avg_sample_rain < 0.2:
					biome = Globals.Biome.PLAINS
				else:
					biome = Globals.Biome.FOREST
		else:
			biome = last_biome
			
		poly_biome_dict[site] = biome
	return poly_biome_dict
