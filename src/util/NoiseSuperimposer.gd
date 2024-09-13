class_name Superimposer

enum LYR_MODE {
	NORMAL,
	DARKEN_ONLY,
	LIGHTEN_ONLY,
	MULTIPLY,
	ADD,
	SUBTRACT,
	DIVIDE,
	DIFFERENCE
}

enum COLOR_MODE {
	RGB,
	HSV,
}

var superimposition_functions : Dictionary = {
	LYR_MODE.NORMAL :			func(a, b): return (a + b) / 2,
	LYR_MODE.DARKEN_ONLY : 		func(a, b): return (a + b) / 2 if b < a else a, 
	LYR_MODE.LIGHTEN_ONLY : 	func(a, b): return (a + b) / 2 if b > a else a,
	LYR_MODE.MULTIPLY : 		func(a, b): return a * b,
	LYR_MODE.DIVIDE : 			func(a, b): return a / b,
	LYR_MODE.ADD : 				func(a,b): return a + b,
	LYR_MODE.SUBTRACT : 		func(a, b): return a - b,
	LYR_MODE.DIFFERENCE : 		func (a, b): return abs(a - b),
}



func superimpose_image(i1 : Image, i2 : Image, i2_opacity : float, \
	layer_mode : LYR_MODE = LYR_MODE.NORMAL, color_mode : COLOR_MODE = COLOR_MODE.RGB):
	if not superimposition_functions.has(layer_mode):
		return
	elif i1.get_height() != i2.get_height() or i1.get_width() != i2.get_width():
		return
	
	i2_opacity = clamp(i2_opacity, 0.0, 1.0)
	var result : Image = i1.duplicate()
	
	var superimpose : Callable = superimposition_functions.get(layer_mode)
	var c1 : Color
	var c2 : Color
	var c_final : Color
	for y in range(result.get_height()):
		for x in range(result.get_width()):
			c1 = i1.get_pixel(x, y)
			c2 = i2.get_pixel(x, y)
			
			match(color_mode):
				COLOR_MODE.RGB:
					c_final.r = superimpose.call(c1.r, c2.r)
					c_final.g = superimpose.call(c1.g, c2.g)
					c_final.b = superimpose.call(c1.b, c2.b)
				COLOR_MODE.HSV:
					c_final.h = superimpose.call(c1.h, c2.h)
					c_final.s = superimpose.call(c1.s, c2.s)
					c_final.v = superimpose.call(c1.v, c2.v)
					
			result.set_pixel(x, y, c_final)
	return result
