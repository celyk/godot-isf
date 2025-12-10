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
	
	var isf_code := shader.code
	#isf_code = _remove_lines_with(isf_code, "shader_type")
	#isf_code = _remove_lines_with(isf_code, "#include")
	
	isf_code = _remove_lines_between(isf_code,"*/", "#include")
	
	#print(isf_code)
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(isf_code)
	
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
