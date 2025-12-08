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
	print("_import time")
	
	
	var path_to_save : String = save_path + '.' + _get_save_extension()
	
	#var scene_type : ISFConverter.SceneType = options["scene_type"]
	
	var converter := ISFConverter.new()
	var isf_file := ISFFile.open(source_file)
	
	var scene_root := converter.convert_isf_to_scene(isf_file)
	
	
	var additional := _import_additional(source_file, save_path)
	
	var include : ShaderInclude = additional["shaderinclude"]
	
	var shader_code := "shader_type canvas_item;\n"
	shader_code += "#define EPIC\n"
	shader_code += "uniform float a;"
	
	include.code = shader_code
	
	_save_additional(source_file, save_path, additional)
	
	#scene_root.material.shader.code = scene_root.material.shader.code
	
	var scene := PackedScene.new()
	scene.pack(scene_root)
	
	#return OK
	return ResourceSaver.save(scene, path_to_save)

func _import_additional(source_file:String, save_path:String) -> Dictionary:
	var dict : Dictionary
	
	var include := ShaderInclude.new()
	var additional_save_path := save_path.get_basename().path_join("generated_inputs.gdshaderinc")
	
	var dir := DirAccess.open("res://")
	if dir.file_exists(additional_save_path):
		include = load(additional_save_path)
	
	dict["shaderinclude"] = include
	
	return dict

func _save_additional(source_file:String, save_path:String, dict:Dictionary) -> void:
	var include : ShaderInclude = dict["shaderinclude"]
	
	var additional_save_path := save_path.get_basename().path_join("generated_inputs.gdshaderinc")
	#append_import_external_resource(additional_save_path)
	
	var dir := DirAccess.open("res://")
	dir.make_dir(additional_save_path.get_base_dir())
	
	ResourceSaver.save(include, additional_save_path)
