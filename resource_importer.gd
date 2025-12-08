@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "ISFImporter"

func _get_visible_name() -> String:
	return "ISF Importer"

func _get_recognized_extensions() -> PackedStringArray:
	return ["fs", "isf"]

func _get_save_extension() -> String:
	return "gdshaderinc"

func _get_resource_type() -> String:
	return "ShaderInclude"

func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return []

func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	print("_import time")
	
	var path_to_save : String = save_path + '.' + _get_save_extension()
	
	var file := FileAccess.open(source_file, FileAccess.READ) 
	var source := file.get_as_text()
	
	
	var shader_include := ShaderInclude.new()
	shader_include.code = '#include "res://addons/godot-isf/include/ISF.gdshaderinc"\n\n' + source
	#shader_include.code += source
	
	
	
	return ResourceSaver.save(shader_include, path_to_save)
	
	#var scene_type : ISFConverter.SceneType = options["scene_type"]
	
	var converter := ISFConverter.new()
	var isf_file := ISFFile.open(source_file)
	
	
	var scene_root := converter.convert_isf_to_scene(isf_file)
	
	var scene := PackedScene.new()
	scene.pack(scene_root)
	
	#return OK
	return ResourceSaver.save(scene, path_to_save)
