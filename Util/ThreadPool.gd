class_name ThreadPool

var active_threads : Dictionary = {}
var thread_queue : Array = []
var on_signal_thread_queue : Dictionary = {}

## unfinished for now, maybe return later
func recheck_queue():
	for thread : Thread in active_threads.keys():
		if !thread.is_alive():
			active_threads[thread] = thread_queue
