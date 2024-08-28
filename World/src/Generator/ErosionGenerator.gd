class_name ErosionGenerator extends GeneratorModule

# Exported variables to control the parameters
@export var erosion_strength: float = 0.1  # Controls the amount of erosion per step
@export var max_droplet_lifetime: int = 30  # Maximum steps a droplet will take
@export var num_droplets: int = 1000000  # Number of droplets to simulate

func generate(generation_cache: Dictionary):
	var width = generation_cache.get("width")
	var height = generation_cache.get("height")
	var heightmap = generation_cache.get("heightmap")
	var old_map = heightmap.duplicate(true)
	var rainfall_map = generation_cache.get("rainfall_map")

	for i in range(num_droplets):
		var x = randi() % width
		var y = randi() % height

		var water = rainfall_map[y][x]
		var sediment = 0.0

		for j in range(max_droplet_lifetime):
			var current_height = heightmap[y][x]
			var lowest_neighbor = current_height
			var new_x = x
			var new_y = y

			# Find the lowest neighboring cell
			for offset_y in range(-1, 2):
				for offset_x in range(-1, 2):
					if offset_x == 0 and offset_y == 0:
						continue
					var neighbor_x = x + offset_x
					var neighbor_y = y + offset_y

					if neighbor_x < 0 or neighbor_x >= width or neighbor_y < 0 or neighbor_y >= height:
						continue

					var neighbor_height = heightmap[neighbor_y][neighbor_x]
					if neighbor_height < lowest_neighbor:
						lowest_neighbor = neighbor_height
						new_x = neighbor_x
						new_y = neighbor_y

			# If the droplet doesn't move, stop simulating this droplet
			if new_x == x and new_y == y:
				break

			# Erode the current cell and carry sediment
			var eroded_amount = erosion_strength * (current_height - lowest_neighbor)
			heightmap[y][x] -= eroded_amount
			sediment += eroded_amount

			# Deposit sediment in the new cell
			heightmap[new_y][new_x] += sediment * 0.1
			sediment *= 0.9

			# Move the droplet
			x = new_x
			y = new_y
	#for x in range(heightmap.size()):
		#for y in range(heightmap[0].size()):
			#if heightmap[y][x] != old_map[y][x]:
				#print("difference at ", y, ",", x, ": ", old_map[y][x] - heightmap[y][x])
	generation_cache["heightmap"] = heightmap
