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

var json : JSON

func parse(source:String) -> void:
	json = _extract_json_from_first_comment(source)
	#print( Array(get_inputs()) )

func get_inputs() -> Array:
	return json.data["INPUTS"]

func get_input_names() -> Array:
	var inputs : Array = get_inputs()
	
	return inputs.map(func(a): return a["NAME"])

func _get_input_internal(name:String) -> Variant:
	var inputs : Array = get_inputs()
	var index := inputs.find_custom(func(a): return a["NAME"] == name)
	return json.data["INPUTS"][index]

func get_input_value(name:String) -> Variant:
	return _get_input_internal(name)["DEFAULT"]

func get_input_type(name:String) -> String:
	return isf_type_map[_get_input_internal(name)["TYPE"]]

func _extract_json_from_first_comment(source:String) -> JSON:
	var json_start : int = source.find("/*") + 2
	var json_end : int = source.find("*/", json_start)
	
	var json_substr : String = source.substr(json_start, json_end-json_start)
	
	#print(json_substr)
	
	var json := JSON.new()
	json.parse(json_substr)
	
	#print(json.data)
	#print(get_inputs())
	
	return json
