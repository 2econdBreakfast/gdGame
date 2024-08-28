class_name DelaunayGenerator extends GeneratorModule

var _delaunay: Delaunay

@export var n : FastNoiseLite 
@export var grid_resolution : Vector2i = Vector2i(20,20)
@export var jitter : int = 150
@export var padding : int = 50
var polys : Array[Polygon2D] = []
var sites : Array = []
@export var map_size : Vector2i
var width
var height


func generate_sites(generation_cache : Dictionary):
	self.width = generation_cache["width"]
	self.height = generation_cache["height"]
	var rect_resolution : Vector2i = Vector2i(width, height)
	_delaunay = Delaunay.new(Rect2(Vector2i.ZERO, rect_resolution))
	
	if n == null: n = FastNoiseLite.new()
	
	for y in range(grid_resolution.y + 1):
		for x in range(grid_resolution.x + 1):
			var nx = n.get_noise_2d(x, y)
			var ny = n.get_noise_2d(y, x)
			var point = Vector2i(x, y) * Vector2i(rect_resolution / grid_resolution) + Vector2i(nx * randi_range(-jitter, jitter), ny * randi_range(-jitter, jitter))
			_delaunay.add_point(point)
			
	var triangles = _delaunay.triangulate()
	self.sites = _delaunay.make_voronoi(triangles)
	
	for site : Delaunay.VoronoiSite in sites:
		var p = site.polygon
		var poly = Polygon2D.new()
		p.append(p[0])
		poly.polygon = p
		polys.append(poly)
		
######################################## placeholder logic ########################################
## actual biome generation logic will be done by BiomeGenerator
## the final version of this class will ONLY generate the mesh
		#var val = (abs(n.get_noise_2dv(site.center)))
		#if val > 0.1:
			#poly.color = Color.FOREST_GREEN
		#else:
			#poly.color = Color.MIDNIGHT_BLUE
		#
		#poly.color.v = 0.2 + 4 * val / 5
		#poly.color.s = 1.0 - val
		#
	##var img : Image = rasterize_polygons_to_image(sites, rect_resolution)
	##var tex : ImageTexture = ImageTexture.create_from_image(img)
	##var sp : Sprite2D = Sprite2D.new()
	##sp.texture = tex	
	##add_child(sp)
	#
	#var map : Array[Array] = rasterize_polygons_to_array(sites, rect_resolution)
	#
	
	
###################################### end placeholder logic ######################################


func rasterize_polygons_to_image(sites: Array, grid_size: Vector2i) -> Image:
	var img : Image = Image.create(width, height, false, Image.FORMAT_RGB8)
	
	# Rasterize each polygon
	for poly_index in range(sites.size()):
		var site : Delaunay.VoronoiSite = sites[poly_index]
		var p = site.polygon
		p.append(p[0])
		var poly : Polygon2D = Polygon2D.new()
		poly.polygon = p
		var boundary : Rect2 = site.get_boundary()
		# Iterate over the bounding box and rasterize the polygon into the grid
		for y in range(int(boundary.position.y), int(boundary.end.y) + 1):
			for x in range(int(boundary.position.x), int(boundary.end.x) + 1):
				var pos = Vector2(x, y)
				if y in range(0, grid_size.y):
					if x in range(0, grid_size.x):
						
						if Geometry2D.is_point_in_polygon(pos, p):
							img.set_pixel(x, y, polys[poly_index].color)
	return img
	
func rasterize_polygons_to_array(sites: Array, grid_size: Vector2i) -> Array[Array]:
	var map : Array[Array] = []
	var row : Array = []
	row.resize(grid_size.x)
	
	for y in range(grid_size.y):
		map.append(row.duplicate(true))
	
	# Rasterize each polygon
	for poly_index in range(sites.size()):
		var site : Delaunay.VoronoiSite = sites[poly_index]
		var p = site.polygon
		p.append(p[0])
		var poly : Polygon2D = Polygon2D.new()
		poly.polygon = p
		var boundary : Rect2 = site.get_boundary()
		# Iterate over the bounding box and rasterize the polygon into the grid
		for y in range(int(boundary.position.y), int(boundary.end.y) + 1):
			for x in range(int(boundary.position.x), int(boundary.end.x) + 1):
				var pos = Vector2(x, y)
				if y in range(0, grid_size.y):
					if x in range(0, grid_size.x):
						
						if Geometry2D.is_point_in_polygon(pos, p):
							map[y][x] = polys[poly_index].color.v
	return map
