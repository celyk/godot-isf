@tool
class_name ISFFile extends RefCounted

var json : JSON
var shader_source : String
var shader_type := VisualShader.Type.TYPE_FRAGMENT

static func open(path:String, flags:=FileAccess.ModeFlags.READ) -> ISFFile:
	var file := FileAccess.open(path, flags) 
	return from_string(file.get_as_text())

static func from_string(source:String) -> ISFFile:
	var isf_file := ISFFile.new()
	isf_file.json = _extract_json_from_first_comment(source)
	return isf_file

static func _extract_json_from_first_comment(source:String) -> JSON:
	var json_start : int = source.find("/*") + 2
	var json_end : int = source.find("*/", json_start)
	
	var json_substr : String = source.substr(json_start, json_end-json_start)

	var json := JSON.new()
	json.parse(json_substr)

	return json
