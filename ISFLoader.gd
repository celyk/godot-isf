@tool
class_name ISFLoader extends RefCounted

var file : FileAccess
var vertex_shader_source : String
var fragment_shader_source : String
var json := {}

var parser := ISFParser.new()


func _init() -> void:
	pass

static func create(path:String) -> ISFLoader:
	var loader := ISFLoader.new()
	loader.file = FileAccess.open(path, FileAccess.READ)
	loader.fragment_shader_source = loader.file.get_as_text()
	
	return loader

func compile_shader(shader_type:=0) -> ShaderMaterial:
	var material := ShaderMaterial.new()
	
	var godot_shader_code := '''// Godot Shader generated from ISF (Interactive Shader Format)

shader_type canvas_item;

#include "res://addons/godot-isf/include/ISF.gdshaderinc"


'''
	
	parser.parse(fragment_shader_source)
	
	for input_name in parser.get_input_names():
		#var value : Variant = parser.get_input_value(input_name)
		var type : String = parser.get_input_type(input_name)
		
		godot_shader_code += get_uniform_declaration_string(type, input_name)
	
	godot_shader_code += "\n\n"
	
	godot_shader_code += fragment_shader_source
	
	material.shader = Shader.new()
	material.shader.code = godot_shader_code
	
	#return preload("uid://cmagfpnocdt2s")
	return material

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
