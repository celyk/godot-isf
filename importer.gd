@tool
extends EditorSceneFormatImporter

func _get_extensions() -> PackedStringArray:
	return ["fs", "isf"]

func _get_import_options(path: String) -> void:
	add_import_option("Test", 0)

func _get_option_visibility(path: String, for_animation: bool, option: String) -> Variant:
	if option == "Test": return null
	
	return false

func _import_scene(source_file: String, flags: int, options: Dictionary) -> Object:
	var control := ColorRect.new()
	control.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	#var path_to_save : String = save_path + '.' + _get_save_extension()
	var loader := ISFLoader.create(source_file)
	var material : ShaderMaterial =  loader.compile_shader()
	
	control.material = material
	
	material.setup_local_to_scene()
	
	return control
