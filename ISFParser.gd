@tool
class_name ISFParser extends RefCounted

const isf_type_map := {
	"event": "bool",
	"bool": "bool",
	"long": "int", 
	"float": "float", 
	"point2D": "Vector2", 
	"color": "Color", 
	"image": "Texture2D", 
	"audio": "Texture2D", 
	"audioFFT": "Texture2D",
}

func parse(source:String) -> void:
	var json : JSON = _extract_json_comment(source)

func get_input(name:String) -> Variant:
	return 0

func _extract_json_comment(source:String) -> JSON:
	var json_start : int = source.find("/*")+2
	var json_end : int = source.find("*/", json_start)
	
	var json_substr : String = source.substr(json_start, json_end-json_start)
	
	#print(json_substr)
	
	var json := JSON.new()
	json.parse(json_substr)
	
	#print(json.data)
	print(json.data["INPUTS"])
	
	return json
