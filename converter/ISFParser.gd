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

var material : ShaderMaterial
var inputs : Array
var buffers : Array

class InputInfo:
	pass

class PassInfo:
	pass

func parse(isf_file:ISFFile) -> void:
	_parse_inputs()
	_parse_buffers()
	
	var material := ShaderMaterial.new()
	material.shader = Shader.new()
	material.shader.code = generate_shader_code()

func _parse_inputs() -> void:
	pass

func _parse_buffers() -> void:
	pass

func generate_shader_code() -> String:
	var godot_shader_code := '''// Godot Shader generated from ISF (Interactive Shader Format)

shader_type canvas_item;

#include "res://addons/godot-isf/include/ISF.gdshaderinc"


'''
	#
	#for input_name in parser.get_input_names():
		##var value : Variant = parser.get_input_value(input_name)
		#var type : String = parser.get_input_type(input_name)
		#
		#godot_shader_code += get_uniform_declaration_string(type, input_name)
	#
	#godot_shader_code += "\n\n"
	#
	#godot_shader_code += fragment_shader_source
	#
	#material.shader = Shader.new()
	#material.shader.code = godot_shader_code
	#
	#return preload("uid://cmagfpnocdt2s")

func get_uniform_declaration_string(type:String, name:String, value:Variant=null) -> String:
	var declaration_string := ""
	
	match type:
		"bool":
			declaration_string = "uniform bool %s" % [name]
		"int":
			declaration_string = "uniform int %s" % [name]
		"float":
			declaration_string = "uniform float %s" % [name]
		"Vector2":
			declaration_string = "uniform vec2 %s" % [name]
		"Color":
			declaration_string = "uniform vec4 %s" % [name]
		"Texture2D":
			declaration_string = "uniform sampler2D %s" % [name]
	
	
	declaration_string += ";\n"
	
	return declaration_string


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
