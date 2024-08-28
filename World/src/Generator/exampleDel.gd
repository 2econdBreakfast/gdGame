class_name ExampleDelaunay extends Node2D

var _delaunay: Delaunay

@export var color_dict : Dictionary = {
	"beige" : [Color.NAVY_BLUE, 0.5],
	"green" : [Color.SEA_GREEN, 1.0]
}
@export var line_color : Color: 
	set(v): 
		_line_color = v
		draw_lines_or_polys()
		
		
var n : FastNoiseLite 
@export var draw_polys : bool
@export var draw_lines : bool
@export var draw_points : bool
@export var draw_tris : bool
var generated : bool = false
@export var auto_update : bool = true
@export var rect_resolution : Vector2i:
	set(v):
		_rect_resolution = v
		if auto_update and generated:
			generate()
	get: return _rect_resolution

@export var polygon_resolution : Vector2i:
	set(v):
		_polygon_resolution = v
		if auto_update and generated:		
			generate()
	get: return _polygon_resolution

@export var jitter : int:
	set(v):
		_jitter = v
		if auto_update and generated:
			generate()
	get: return _jitter

var _rect_resolution : Vector2i
var _polygon_resolution : Vector2i
var _jitter : int
var _line_color : Color
var _lines : Array[Line2D]
var _polygons : Array[Polygon2D]
var _sites : Array
var _triangles : Array

func _ready():
	n = FastNoiseLite.new() 
	generate()
	
func reset():
	_polygons.clear()
	_lines.clear()
	_sites.clear()
	
	n = FastNoiseLite.new()
	n.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	n.frequency = 0.001
	n.fractal_octaves = 4
	n.fractal_gain = 10
	n.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
	# Clear all previous children (drawings)
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	_delaunay = Delaunay.new(Rect2(Vector2.ZERO, rect_resolution))
	randomize()
	
func generate():
	reset()
	var padding : Vector2 = Vector2.ONE * 50
	
	for y in range(polygon_resolution.y):
		for x in range(polygon_resolution.x):
			var y_jitter = randi_range(-jitter, jitter)
			var x_jitter = randi_range(-jitter, jitter)
			
			var y_point : float = y * (rect_resolution.y / polygon_resolution.y) + y_jitter
			
			var x_point : float = x * (rect_resolution.x / polygon_resolution.x) + x_jitter
			
			
			add_point(Vector2(x_point, y_point))
			
	_triangles = _delaunay.triangulate()
	_sites = _delaunay.make_voronoi(_triangles)
	
	if (draw_points):
		show_points()
	
	if(draw_polys or draw_lines):
		draw_lines_or_polys()


	if(draw_tris):
		draw_triangles()
	
	generated = true

func draw_lines_or_polys():
	for site : Delaunay.VoronoiSite in _sites:
		var centroid = site.center.clamp(Vector2i.ZERO, rect_resolution - Vector2i.ONE)
		var tot : float = 0
		var count : int = 0

		for x in range(11):  # Include the range [0, 10]
			for y in range(11):
				if x == 0 and y == 0:
					continue  # Skip the center point itself if not needed

				# Handle cases where x or y is 0 to avoid double counting
				if x == 0:
					tot += abs(n.get_noise_2d(centroid.x, centroid.y + y))
					tot += abs(n.get_noise_2d(centroid.x, centroid.y - y))
					count += 2
				elif y == 0:
					tot += abs(n.get_noise_2d(centroid.x + x, centroid.y))
					tot += abs(n.get_noise_2d(centroid.x - x, centroid.y))
					count += 2
				else:
					# All four quadrants are included when both x and y are non-zero
					tot += abs(n.get_noise_2d(centroid.x + x, centroid.y + y))
					tot += abs(n.get_noise_2d(centroid.x + x, centroid.y - y))
					tot += abs(n.get_noise_2d(centroid.x - x, centroid.y + y))
					tot += abs(n.get_noise_2d(centroid.x - x, centroid.y - y))
					count += 4
		# Calculate the average noise value
		var avg_noise = tot / float(count)
		var col = get_color_for_val(avg_noise)
		show_site(site, col)

			
func draw_triangles():
	for triangle in _triangles:
		if not _delaunay.is_border_triangle(triangle):
			show_triangle(triangle)
	#for site in sites:
		#if site.neighbours.size() != site.source_triangles.size():
			#continue # Sites on edges will have incomplete neighbour information
		#for nb in site.neighbours:
			#show_neighbour(nb)
func get_color_for_val(height_value) -> Color:
	if (color_dict.keys().size() > 0):
		for color in color_dict.keys():
			if clamp(height_value, 0, 1.0) <= color_dict[color][1]:
				print(color_dict[color][1])
				return color_dict[color][0]
	
	return Color.PALE_VIOLET_RED

func add_point(point: Vector2):
	var polygon = Polygon2D.new()
	var p = PackedVector2Array()
	var s = 5
	p.append(Vector2(-s, s))
	p.append(Vector2(s, s))
	p.append(Vector2(s, -s))
	p.append(Vector2(-s, -s))
	polygon.polygon = p
	polygon.color = Color.BURLYWOOD
	polygon.position = point
	_delaunay.add_point(point)

func show_points():
	for p in _polygons:
		add_child(p)

func show_triangle(triangle: Delaunay.Triangle):
	var line = Line2D.new()
	var p = PackedVector2Array()
	p.append(triangle.a)
	p.append(triangle.b)
	p.append(triangle.c)
	p.append(triangle.a)
	line.points = p
	line.width = 1
	line.antialiased = true
	add_child(line)

func show_site(site: Delaunay.VoronoiSite, value  : Color):
	var p = site.polygon
	var padding

	p.append(p[0])
	
	if (draw_lines):
		var line = Line2D.new()		
		line.points = p
		line.width = 1
		line.default_color = _line_color
		_lines.append(line)
		add_child(line)
		
	if (draw_polys):
		var polygon = Polygon2D.new()
		polygon.polygon = p
		polygon.color = value
		polygon.z_index = -1
		_polygons.append(polygon)
		add_child(polygon)
		
func show_neighbour(edge: Delaunay.VoronoiEdge):
	var line = Line2D.new()
	var points = PackedVector2Array()
	var l = 6
	var s = lerp(edge.a, edge.b, 0.6)
	var dir = edge.a.direction_to(edge.b).orthogonal()
	points.append(s + dir * l)
	points.append(s - dir * l)
	line.points = points
	line.width = 1
	line.default_color = Color.CYAN
	add_child(line)

func to_biome_map():
	var biome_map :Array[Array] = []
	biome_map.resize(512)
	for y in range(biome_map.size()):
		biome_map[y].resize(512)
		for x in range(biome_map[y].size()):
			pass
