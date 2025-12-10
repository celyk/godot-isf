#@tool
#class_name ResourceFormatLoaderISF 
extends ResourceFormatLoader

func _get_recognized_extensions() -> PackedStringArray:
	return ["fs"]

func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
	print("loading")
	var shader := load(path.get_basename()+".gdshader")
	
	return shader

static func _get_folder_hash(path:String) -> String:
	return str(path.get_file().get_basename().hash())

func _get_dependencies(path: String, add_types: bool) -> PackedStringArray:
	var hash := _get_folder_hash(path)
	var additional_folder := path.get_base_dir().path_join("ISF").path_join(hash)
	
	var include_path := additional_folder.path_join("generated_inputs.gdshaderinc")
	print(include_path)
	return [include_path]
