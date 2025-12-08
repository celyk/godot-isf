@tool
extends EditorSceneFormatImporter

func _get_extensions() -> PackedStringArray:
	return ["fs", "isf"]

var _options : PackedStringArray
func _add_import_option_helper(name: String, value: Variant, type:Variant.Type=TYPE_NIL, hint:PropertyHint=PROPERTY_HINT_NONE, hint_string:String="", usage_flags:int=6):
	_options.append(name)
	
	if type == TYPE_NIL:
		add_import_option(name, value)
	else:
		add_import_option_advanced(type, name, value, hint, hint_string, usage_flags)

func _get_import_options(path: String) -> void:
	_add_import_option_helper("scene_type", ISFConverter.SceneType.CONTROL, TYPE_INT, PROPERTY_HINT_ENUM, "Control,Node2D,Node3D", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED)
	#_add_import_option_helper("test", 0)

# Remove all the built in options that we can
func _get_option_visibility(path: String, for_animation: bool, option: String) -> Variant:
	if option in _options: return null
	return false

func _import_scene(source_file: String, flags: int, options: Dictionary) -> Object:
	var scene_type : ISFConverter.SceneType = options["scene_type"]
	
	var converter := ISFConverter.new()
	var isf_file := ISFFile.open(source_file)
	
	var scene_root := converter.convert_isf_to_scene(isf_file)
	
	var loader := ISFLoader.create(source_file)
	var material : ShaderMaterial =  loader.compile_shader()
	material.resource_local_to_scene = true
	
	return scene_root
