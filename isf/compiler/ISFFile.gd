@tool
class_name ISFFile extends RefCounted

var path : String
var json : JSON
var shader_source : String
var shader_type := VisualShader.Type.TYPE_FRAGMENT

static func open(path:String, flags:=FileAccess.ModeFlags.READ) -> ISFFile:
	var file := FileAccess.open(path, flags) 
	var isf_file := from_string(file.get_as_text())
	isf_file.path = path
	return isf_file

static func from_string(source:String) -> ISFFile:
	var isf_file := ISFFile.new()
	isf_file.json = _extract_json_from_first_comment(source)
	isf_file.shader_source = _extract_shader_source(source)
	return isf_file

static func _extract_json_from_first_comment(source:String) -> JSON:
	var json_start : int = source.find("/*") + 2
	var json_end : int = source.find("*/", json_start)
	
	var json_substr : String = source.substr(json_start, json_end-json_start)

	var json := JSON.new()
	json.parse(json_substr)
	print(json.data)
	return json

static func _extract_shader_source(source:String) -> String:
	var json_start : int = source.find("/*") + 2
	var json_end : int = source.find("*/", json_start)
	return source.substr(json_end+3)

func save(path:String) -> Error:
	var file := FileAccess.open(path, FileAccess.ModeFlags.WRITE)
	
	var source : String = "/*\n" + JSON.stringify(json.data, "\t") + "\n*/\n" + shader_source
	print(source)
	if not file.store_string(source):
		return ERR_CANT_OPEN
	
	#file.close()
	
	return OK
