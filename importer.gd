@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "ISFImporter"

func _get_visible_name() -> String:
	return "ISFImporter"

func _get_recognized_extensions() -> PackedStringArray:
	return [".fs", ".isf"]

func _get_save_extension() -> String:
	return ".isfimported"

func _get_resource_type() -> String:
	return "Shader"
