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
var inputs : Dictionary
var passes : Array
#var buffers : Array
var persistent_buffers : Array

class InputInfo:
	pass

class PassInfo:
	pass

func parse(isf_file:ISFFile) -> void:
	_parse_inputs(isf_file)
	_parse_buffers(isf_file)
	
	var material := ShaderMaterial.new()
	material.shader = Shader.new()
	material.shader.code = generate_shader_code()

func _parse_inputs(isf_file:ISFFile) -> void:
	for input in isf_file.json.data["INPUTS"]:
		inputs

func _parse_buffers(isf_file:ISFFile) -> void:
	for input in isf_file.json.data["INPUTS"]:
		passes

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
	return ""

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
