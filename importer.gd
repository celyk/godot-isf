@tool
extends EditorSceneFormatImporter

func _get_extensions() -> PackedStringArray:
	return ["fs", "isf"]

enum SceneType {CONTROL, NODE_2D, NODE_3D}

var _extensions : PackedStringArray
func _add_import_option_helper(name: String, value: Variant, type:Variant.Type=TYPE_NIL, hint:PropertyHint=PROPERTY_HINT_NONE, hint_string:String="", usage_flags:int=6):
	_extensions.append(name)
	
	if type == TYPE_NIL:
		add_import_option(name, value)
	else:
		add_import_option_advanced(type, name, value, hint, hint_string, usage_flags)

func _get_import_options(path: String) -> void:
	_add_import_option_helper("scene_type", SceneType.CONTROL, TYPE_INT, PROPERTY_HINT_ENUM, "Control,Node2D,Node3D", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED)
	_add_import_option_helper("test", 0)

# Remove all the built in options that we can
func _get_option_visibility(path: String, for_animation: bool, option: String) -> Variant:
	if option in _extensions: return null
	return false

func _import_scene(source_file: String, flags: int, options: Dictionary) -> Object:
	var scene_type : SceneType = options["scene_type"]
	var scene_root := Node.new()
	
	#var path_to_save : String = save_path + '.' + _get_save_extension()
	var loader := ISFLoader.create(source_file)
	var material : ShaderMaterial =  loader.compile_shader()
	material.resource_local_to_scene = true
	
	var mesh := QuadMesh.new()
	
	match scene_type:
		"Control":
			scene_root = ColorRect.new()
			scene_root.set_anchors_preset(Control.PRESET_FULL_RECT)
			scene_root.material = material
		"Node2D":
			scene_root = MeshInstance2D.new()
			scene_root.mesh = mesh
			scene_root.material = material
		"Node3D":
			scene_root = MeshInstance3D.new()
			scene_root.mesh = mesh
			scene_root.material_override = material
	
	return scene_root
