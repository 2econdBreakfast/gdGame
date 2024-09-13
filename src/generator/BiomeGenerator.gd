class_name BiomeGenerator extends GeneratorModule

@export var noise : FastNoiseLite
@export var polygon_grid_size : Vector2i
@export var rect_padding : int
@export var data_sample_range_from_poly_center = 2
@export var max_lakes = 1


func generate(generation_cache : Dictionary):
	var width = generation_cache["width"]
	var height = generation_cache["height"]
	var map_data = generation_cache["map_data"]

	var biome_polys = get_all_polygons(noise, width, height)
	assign_biomes(biome_polys, map_data, width, height)

	generation_cache["biomes"] = biome_polys

func assign_biomes(polys: Array, map_data : Array[Array], width: int, height: int):
	
	for polygon in polys:
		var tot_sample_height: float = 0
		var tot_sample_rain: float = 0
		var tot_count: float = 0
		var biome = Globals.Biome.OCEAN
		
		for point in polygon:
			var x = int(point.x)
			var y = int(point.y)
			var tile = map_data[y][x] as MapTileData
			
			# Ensure the point is within bounds
			if y >= 0 and y < height and x >= 0 and x < width:
				tot_count += 1
				tot_sample_rain += tile.rainfall
				tot_sample_height += tile.height
		
		# Calculate averages if we have valid samples
		if tot_count > 0:
			var avg_sample_height = tot_sample_height / tot_count
			var avg_sample_rain = tot_sample_rain / tot_count
			
			# Determine biome based on average height and rainfall
			if avg_sample_rain < 0:
				biome = Globals.Biome.PLAINS
			else:
				biome = Globals.Biome.FOREST
		
		# Assign the calculated biome to all points in the polygon in the 2D array
		for point in polygon:
			var tile = map_data[point.y][point.x]
			tile.biome = biome

func get_all_polygons(noise, width, height):
	var polygons = []
	var checked : Array[Array] = ArrayOps.new_2d_arr(height, width)
	
	for y in range(height):
		for x in range(width):
			# If the cell hasn't been checked, perform a flood fill to get the polygon
			if not checked[y][x]:
				var polygon = select_touching_by_color(noise, x, y, width, height)
				
				# Mark all cells in this polygon as checked
				for cell in polygon:
					checked[cell.y][cell.x] = true
				
				# Add the polygon to the list of polygons
				polygons.append(polygon)
	
	return polygons

func select_touching_by_color(noise_instance: FastNoiseLite, start_x, start_y, width, height):
	var target_value = noise_instance.get_noise_2d(start_x, start_y)	
	var selected_cells = []
	var stack = [Vector2(start_x, start_y)]
	var checked = ArrayOps.new_2d_arr(height, width)
	
	while stack.size() > 0:
		var current = stack.pop_back()
		var cx = int(current.x)
		var cy = int(current.y)
		
		# Skip if out of bounds or already checked
		if cx < 0 or cx >= width or cy < 0 or cy >= height:
			continue
		if checked[cy][cx]:
			continue
		
		# Mark this cell as checked
		checked[cy][cx] = true
		
		# Get the noise value for the current point
		var current_value = noise_instance.get_noise_2d(cx, cy)
		
		# If the noise value is approximately equal to the target value, add it to the selection
		if is_equal_approx(current_value, target_value):
			selected_cells.append(current)
			
			# Add neighboring cells to the stack
			stack.append(Vector2(cx + 1, cy))
			stack.append(Vector2(cx - 1, cy))
			stack.append(Vector2(cx, cy + 1))
			stack.append(Vector2(cx, cy - 1))
	
	return selected_cells
