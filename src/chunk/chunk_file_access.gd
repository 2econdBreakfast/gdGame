# ChunkFileAccess.gd

class_name ChunkFileAccess extends Node  # We extend Node to use signals

signal map_save_complete(success)
signal map_load_complete(success)


var chunk_data_map = {}  # Dictionary to hold chunk data in memory

var save_thread: Thread = null
var load_thread: Thread = null

var save_in_progress: bool = false
var load_in_progress: bool = false

var save_mutex: Mutex = Mutex.new()
var load_mutex: Mutex = Mutex.new()

# Existing methods...

# Function to save the entire map
func save_map():
	if save_in_progress:
		print("Save already in progress")
		return
	save_in_progress = true
	save_thread = Thread.new()
	# Lock the mutex to safely copy the chunk_data_map
	save_mutex.lock()
	var data_to_save = chunk_data_map.duplicate(true)  # Deep copy
	save_mutex.unlock()
	# Start the thread using Callable.bind()
	var callable = Callable(self, "_threaded_save_map").bind(data_to_save)
	var result = save_thread.start(callable)
	if result != OK:
		print("Failed to start save thread")
		save_in_progress = false
		save_thread = null

func _threaded_save_map(data_to_save):
	var success = false
	var path = "user://world_save.dat"
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_var(data_to_save)
		file.close()
		print("Map saved to ", path)
		success = true
	else:
		print("Failed to open file for saving map at ", path)
	# Signal the main thread that save is complete
	call_deferred("_on_save_complete", success)
	# Clean up the thread
	save_in_progress = false
	if save_thread:
		save_thread.wait_to_finish()
		save_thread = null

func _on_save_complete(success):
	emit_signal("map_save_complete", success)

# Function to load the entire map
func load_map():
	if load_in_progress:
		print("Load already in progress")
		return
	load_in_progress = true
	load_thread = Thread.new()
	# Start the thread using Callable
	var callable = Callable(self, "_threaded_load_map")
	var result = load_thread.start(callable)
	if result != OK:
		print("Failed to start load thread")
		load_in_progress = false
		load_thread = null

func _threaded_load_map():
	var success = false
	var path = "user://world_save.dat"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			file.close()
			# Lock the mutex to safely update chunk_data_map
			load_mutex.lock()
			chunk_data_map = loaded_data
			load_mutex.unlock()
			print("Map loaded from ", path)
			success = true
		else:
			print("Failed to open file for loading map at ", path)
	else:
		print("No saved map at ", path)
	# Signal the main thread that load is complete
	call_deferred("_on_load_complete", success)
	# Clean up the thread
	load_in_progress = false
	if load_thread:
		load_thread.wait_to_finish()
		load_thread = null

func _on_load_complete(success):
	emit_signal("map_load_complete", success)
