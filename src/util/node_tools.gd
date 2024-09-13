class_name NodeTools

func get_node_children_of_type(parent : Node, type) :
	var result : Array[GeneratorModule] = []
	for node : Node in parent .get_children():
		if typeof(node) == typeof(type):
			result.append(node)
	return type
