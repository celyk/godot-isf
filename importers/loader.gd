#@tool
#class_name ResourceFormatLoaderISF 
extends ResourceFormatLoader

func _get_recognized_extensions() -> PackedStringArray:
	return ["fs"]

func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
	print("loading")
	var shader := load(path.get_basename()+".gdshader")
	return shader
