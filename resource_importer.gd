@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "ISFImporter"

func _get_visible_name() -> String:
	return "ISF Importer"

func _get_recognized_extensions() -> PackedStringArray:
	return ["fs", "isf"]

func _get_save_extension() -> String:
	return "tscn"

func _get_resource_type() -> String:
	return "PackedScene"

func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return []

func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var path_to_save : String = save_path + '.' + _get_save_extension()
	
	#var scene_type : ISFConverter.SceneType = options["scene_type"]
	
	var converter := ISFConverter.new()
	var isf_file := ISFFile.open(source_file)
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	var scene_root := converter.convert_isf_to_scene(isf_file)
	
	
	var additional := _import_additional(source_file, save_path)
	
	var include : ShaderInclude = additional["shaderinclude"]
	var shader : Shader = additional["shader"]
	
	var include_code := "\n"
	#shader_code += "shader_type canvas_item;\n"
	#include_code += "#define EPIC\n"
	#include_code += "uniform float a;\n"
	include_code += parser.generate_shader_uniform_declarations() + "\n\n"
	include_code += '#include "res://addons/godot-isf/include/ISF.gdshaderinc"\n\n'
	
	include.code = include_code
	
	
	var shader_code : String = "/*\n" + JSON.stringify(isf_file.json.data, "\t") + "\n*/\n\n"
	shader_code += "shader_type canvas_item;\n\n"
	shader_code += '#include "generated_inputs.gdshaderinc"\n\n'
	#shader_code += '#include "res://addons/godot-isf/include/ISF.gdshaderinc"\n\n'
	shader_code += isf_file.shader_source
	
	
	
	shader.code = shader_code
	
	_save_additional(source_file, save_path, additional)
	
	scene_root.material.shader = shader
	
	var scene := PackedScene.new()
	scene.pack(scene_root)
	
	#return OK
	return ResourceSaver.save(scene, path_to_save)

func _import_additional(source_file:String, save_path:String) -> Dictionary:
	var dict : Dictionary
	
	var dir := DirAccess.open("res://")
	
	var include := ShaderInclude.new()
	
	var folder_name := save_path.get_file().get_basename()
	folder_name = folder_name.reverse()
	var folder_path := save_path.get_base_dir().path_join(folder_name)
	var additional_save_path := folder_path.path_join("generated_inputs.gdshaderinc")
	
	print("additional_save_path ", additional_save_path)
	#EditorInterface.get_resource_filesystem().update_file(additional_save_path)
	append_import_external_resource(additional_save_path)
	#EditorInterface.get_resource_filesystem().scan()
	
	if dir.file_exists(additional_save_path):
		include = load(additional_save_path)
	
	dict["shaderinclude"] = include
	
	additional_save_path = folder_path.path_join("generated_shader.gdshader")
	
	var shader := Shader.new()
	
	EditorInterface.get_resource_filesystem().update_file(additional_save_path)
	append_import_external_resource(additional_save_path)
	
	if dir.file_exists(additional_save_path):
		print("file_exists")
		shader = load(additional_save_path)
	
	
	dict["shader"] = shader
	
	return dict

func _save_additional(source_file:String, save_path:String, dict:Dictionary) -> void:
	var include : ShaderInclude = dict["shaderinclude"]
	var shader : Shader = dict["shader"]
	
	var folder_name := save_path.get_file().get_basename()
	folder_name = folder_name.reverse()
	var folder_path := save_path.get_base_dir().path_join(folder_name)
	var additional_save_path := folder_path.path_join("generated_inputs.gdshaderinc")
	
	var dir := DirAccess.open("res://")
	dir.make_dir(additional_save_path.get_base_dir())
	
	ResourceSaver.save(include, additional_save_path)
	EditorInterface.get_resource_filesystem().update_file(additional_save_path)
	
	additional_save_path = folder_path.path_join("generated_shader.gdshader")
	ResourceSaver.save(shader, additional_save_path)
	EditorInterface.get_resource_filesystem().update_file(additional_save_path)
