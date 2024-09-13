class_name ArrayOps


static func sum(arr : Array):
	if arr.size() == 0:
		return 0
	elif arr.size() == 1:
		return arr[0]
	else:
		var result = arr[0]
		for i in range(1, arr.size()):
			result += arr[i]
		return result

static func average(arr : Array):
	return \
		0 if arr.size() == 0 \
		else ArrayOps.sum(arr) / arr.size()
		
static func new_2d_arr(rows, columns):
	var result : Array[Array]
	if rows > 0:
		result.resize(rows)
		if columns > 0:
			for y in range(rows):
				result[y].resize(columns)
			
	return result
		
