@tool
class_name ISFParser extends RefCounted

var version : String
var credit : String
var categories : Array#[String]

var material : ShaderMaterial
var inputs : Array[InputInfo]
var passes : Array[BufferInfo]
#var persistent_buffers : Array
var imported_images : Array[ImportedImageInfo]

var _isf_file : ISFFile

class InputInfo extends RefCounted:
	enum InputType {EVENT, BOOL, LONG, FLOAT, POINT2D, COLOR, IMAGE, AUDIO, AUDIOFFT}
	
	var name : String
	var label : String
	var type : InputType
	var default_value : Variant
	var min : float
	var max : float
	var identity : float
	
	func get_godot_type() -> String:
		const map := {
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

class ImportedImageInfo extends RefCounted:
	var target : String
	var path : String
	var texture : Texture

class BufferInfo extends RefCounted:
	var target : String
	var persistent : bool = false
	var width : int = 512
	var height : int = 512


func parse(isf_file:ISFFile) -> void:
	_isf_file = isf_file
	
	version = isf_file.json.data.get("ISFVSN", "2.0")
	credit = isf_file.json.data.get("CREDIT", "")
	categories = isf_file.json.data.get("CATEGORIES", [])
	
	_parse_inputs(isf_file)
	_parse_imported(isf_file)
	_parse_buffers(isf_file)
	
	material = ShaderMaterial.new()
	material.shader = Shader.new()
	material.shader.code = generate_shader_code()

func _parse_inputs(isf_file:ISFFile) -> void:
	for dict in isf_file.json.data.get("INPUTS", []):
		var info := InputInfo.new()
		info.name = dict["NAME"]
		info.type = InputInfo.InputType[ dict["TYPE"].to_upper() ]
		
		if dict.has("DEFAULT"):
			var value : Variant = dict.get("DEFAULT")
			if value is Array:
				match value.size():
					2:
						value = Vector2(value[0], value[1])
					3:
						value = Vector3(value[0], value[1], value[2])
					4:
						value = Vector4(value[0], value[1], value[2], value[3])
			
			if info.type == InputInfo.InputType.COLOR:
				value = Color(value.x, value.y, value.z, value.w)
			
			info.default_value = value
		
		inputs.append(info)

func _parse_buffers(isf_file:ISFFile) -> void:
	for dict in isf_file.json.data.get("PASSES", []):
		var info := BufferInfo.new()
		info.target = dict.get("TARGET", "")
		info.persistent = dict.get("PERSISTENT", false)
		
		#var isf_expression := ISFExpression.new()
		#isf_expression.parse(dict.get("WIDTH", "0"), ["WIDTH"])
		#info.width = isf_expression.execute([info.width])
		#isf_expression.parse(dict.get("HEIGHT", "0"), ["HEIGHT"])
		#info.height = isf_expression.execute([info.height])
		#
		info.width = dict.get("WIDTH", "0")
		info.height = dict.get("HEIGHT", "0")
		
		# Buffer is not valid
		if info.target == "": continue
		
		passes.append(info)

func _parse_imported(isf_file:ISFFile) -> void:
	if not isf_file.json.data.has("IMPORTED"): return
	
	var keys : Array = isf_file.json.data.get("IMPORTED").keys()
	for key in keys:
		var dict : Dictionary = isf_file.json.data.get("IMPORTED").get(key)
		
		var info := ImportedImageInfo.new()
		info.target = key
		info.path = dict.get("PATH", "")
		
		if isf_file.path:
			var tex : Texture = load(isf_file.path.get_base_dir().path_join(info.path))
			if tex:
				info.texture = tex
		
		imported_images.append(info)

func generate_shader_code() -> String:
	var godot_shader_code := '''// Godot Shader generated from ISF (Interactive Shader Format)

shader_type canvas_item;

#include "res://addons/godot-isf/include/ISF.gdshaderinc"


'''
	
	godot_shader_code += generate_shader_uniform_declarations()
	godot_shader_code += "\n\n"
	
	godot_shader_code += _isf_file.shader_source
	
	return godot_shader_code

func generate_json() -> JSON:
	var json := JSON.new()
	
	json.data = {}
	
	if version:
		json.data["VERSION"] = version
		
	if credit:
		json.data["CREDIT"] = credit
	
	if categories:
		json.data["CATEGORIES"] = categories
	
	if inputs:
		json.data["INPUTS"] = []
	
	for input_info in inputs:
		json.data["INPUTS"].append({})
	
	if passes:
		json.data["PASSES"] = []
	
	for buffer_info in passes:
		json.data["PASSES"].append({})
	
	return json

func generate_shader_uniform_declarations() -> String:
	var godot_shader_code := ""
	
	godot_shader_code += "// INPUTS \n"
	for input_info in inputs:
		godot_shader_code += get_uniform_declaration_string(input_info.get_godot_type(), input_info.name)
	
	godot_shader_code += "\n\n"
	
	godot_shader_code += "// IMPORTED \n"
	for imported_info in imported_images:
		godot_shader_code += get_uniform_declaration_string("Texture2D", imported_info.target)
	
	godot_shader_code += "\n\n"
	
	godot_shader_code += "// PASSES \n"
	for buffer_info in passes:
		godot_shader_code += get_uniform_declaration_string("Texture2D", buffer_info.target)
	
	
	return godot_shader_code

func get_uniform_declaration_string(type:String, name:String, value:Variant=null) -> String:
	var declaration_string := ""
	
	match type:
		"bool":
			declaration_string = "uniform bool %s;" % [name]
		"int":
			declaration_string = "uniform int %s;" % [name]
		"float":
			declaration_string = "uniform float %s;" % [name]
		"Vector2":
			declaration_string = "uniform vec2 %s;" % [name]
		"Color":
			declaration_string = "uniform vec4 %s : source_color;" % [name]
		"Texture2D":
			declaration_string = "uniform sampler2D %s : source_color;" % [name]
	
	
	declaration_string += "\n"
	
	return declaration_string

static func find_function(source:String, name:String) -> int:
	var name_start := source.find(name+"()")
	var line_start := source.rfind("\n", name_start)
	return line_start
