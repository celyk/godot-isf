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
	
	var godot_shader_code := '''// Godot Shader converted from ISF (Interactive Shader Format)

shader_type canvas_item;

#include "res://addons/godot-isf/include/ISF.gdshaderinc"


'''
	
	godot_shader_code += fragment_shader_source
	
	material.shader = Shader.new()
	material.shader.code = godot_shader_code
	
	parser.parse(fragment_shader_source)

	
	return preload("uid://cmagfpnocdt2s")
	return material
	

func parse_json():
	pass
