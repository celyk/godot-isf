@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "ISFImporter"

func _get_visible_name() -> String:
	return "ISFImporter"

func _get_recognized_extensions() -> PackedStringArray:
	return ["fs", "isf"]

func _get_save_extension() -> String:
	return ".isfimported"

func _get_resource_type() -> String:
	return "ShaderMaterial"

func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return []

func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var path_to_save : String = save_path + '.' + _get_save_extension()
	
	var loader := ISFLoader.new()
	
	var material : ShaderMaterial =  loader.compile_shader()
	
	return ResourceSaver.save(material, path_to_save)
