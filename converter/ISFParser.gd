@tool
class_name ISFParser extends RefCounted

var version : String
var credit : String
var categories : Array #[String]

var material : ShaderMaterial
var inputs : Array[InputInfo]
var passes : Array[BufferInfo]
var persistent_buffers : Array

var _isf_file : ISFFile

class InputInfo extends RefCounted:
	enum InputType {EVENT, BOOL, LONG, FLOAT, POINT2D, COLOR, IMAGE, AUDIO, AUDIOFFT}
	
	var name : String
	var label : String
	var type : InputType
	var default : float
	var min : float
	var max : float
	var identity : float
	
	func get_godot_type() -> String:
		var map := {
			InputType.EVENT: "bool",
			InputType.BOOL: "bool",
			InputType.LONG: "int", 
			InputType.FLOAT: "float", 
			InputType.POINT2D: "Vector2", 
			InputType.COLOR: "Color", 
			InputType.IMAGE: "Texture2D", 
			InputType.AUDIO: "Texture2D", 
			InputType.AUDIOFFT: "Texture2D",
		}
		return map[type]

class BufferInfo extends RefCounted:
	var target : String
	var persistent : bool = false
	var width : int = 512
	var height : int = 512

func parse(isf_file:ISFFile) -> void:
	_isf_file = isf_file
	
	version = isf_file.json.data["ISFVSN"]
	credit = isf_file.json.data["CREDIT"]
	categories = isf_file.json.data["CATEGORIES"]
	
	_parse_inputs(isf_file)
	_parse_buffers(isf_file)
	
	material = ShaderMaterial.new()
	material.shader = Shader.new()
	material.shader.code = generate_shader_code()

func _parse_inputs(isf_file:ISFFile) -> void:
	for dict in isf_file.json.data["INPUTS"]:
		var info := InputInfo.new()
		info.name = dict["NAME"]
		info.type = InputInfo.InputType[ dict["TYPE"].to_upper() ]
		inputs.append(info)

func _parse_buffers(isf_file:ISFFile) -> void:
	for dict in isf_file.json.data["INPUTS"]:
		var info := BufferInfo.new()
		info.target = dict.get("TARGET", "")
		info.width = dict.get("WIDTH", 0)
		info.height = dict.get("HEIGHT", 0)
		info.persistent = dict.get("PERSISTENT", false)
		passes.append(info)

func generate_shader_code() -> String:
	var godot_shader_code := '''// Godot Shader generated from ISF (Interactive Shader Format)

shader_type canvas_item;

#include "res://addons/godot-isf/include/ISF.gdshaderinc"


'''
	
	for input_info in inputs:
		godot_shader_code += get_uniform_declaration_string(input_info.get_godot_type(), input_info.name)
	
	godot_shader_code += "\n\n"
	
	godot_shader_code += _isf_file.shader_source
	
	return godot_shader_code

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
