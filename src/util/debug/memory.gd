class_name Debug extends Node


class Memory:
	static func print_mem_usage(message : String = ""):
		if !message.is_empty():
			print(message)
		print("Dynamic Memory Usage: ", OS.get_memory_info(), " bytes")
