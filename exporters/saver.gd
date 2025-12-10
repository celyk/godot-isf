@tool
class_name ResourceFormatSaverISF extends ResourceFormatSaver

func _get_recognized_extensions(resource: Resource) -> PackedStringArray:
	return ["fs"]

func _recognize(resource: Resource) -> bool:
	if resource is Shader:
		return true
	
	return false

func _save(resource: Resource, path: String, flags: int) -> Error:
	#print("saving not");return OK
	
	var shader : Shader = resource
	print("resource_path ", shader.resource_path)
	var isf_code := shader.code
	shader.code = shader.code
	#isf_code = _remove_lines_with(isf_code, "shader_type")
	#isf_code = _remove_lines_with(isf_code, "#include")
	
	var json_start := isf_code.find("/*")
	isf_code = isf_code.substr(json_start)
	
	#isf_code = _remove_lines_between(isf_code,"*/", "#include")
	
	#print(isf_code)
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(isf_code)
	file.close()
	
	#var dependencies := ResourceLoader.get_dependencies(path)
	#print("depend: ", dependencies)
	#
	#dependencies = _get_dependencies(path, false)
	##dependencies.append(path)
	#
	#for d in dependencies:
		#EditorInterface.get_resource_filesystem().update_file(d)
	#
	
	#EditorInterface.get_resource_filesystem().reimport_files(dependencies)
	EditorInterface.get_resource_filesystem().reimport_files([path])
	
	return OK
	
	
	#shader.notify_property_list_changed()
	#shader.emit_changed()
	
	
	
	shader = ResourceLoader.load(path)
	
	print(isf_code)
	shader.emit_changed.call_deferred()
	
	#shader.take_over_path(shader.resource_path)
	
	return OK

func _remove_lines_between(source:String, start_key:String, end_key:String) -> String:
	var start := _get_line_start(source, source.find(start_key))
	var end := _get_line_end(source, source.find(end_key))
	
	source = source.erase(start, end - start + 1)
	
	return source

func _remove_lines_with(source:String, key:String) -> String:
	var start := 0
	
	while start != -1:
		start = source.find(key)
		var end = source.find("\n", start)
		
		#print(source.substr(start, end - start))
		
		if start != -1:
			source = source.erase(start, end - start + 1)
		#break
	
	#var isf_code.find()
	
	return source

func _get_line_start(source:String, index:int) -> int:
	return source.rfind("\n", index)+1

func _get_line_end(source:String, index:int) -> int:
	return source.find("\n", index)-1

static func _get_folder_hash(path:String) -> String:
	return str(path.get_file().get_basename().hash())

func _get_dependencies(path: String, add_types: bool) -> PackedStringArray:
	var hash := _get_folder_hash(path)
	var additional_folder := path.get_base_dir().path_join("ISF").path_join(hash)
	
	var include_path := additional_folder.path_join("generated_inputs.gdshaderinc")
	print(include_path)
	return [include_path]
