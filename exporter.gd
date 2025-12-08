extends EditorFileDialog


func export() -> void:
	popup_file_dialog()

func _init() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	add_filter("*.fs", "ISF Fragment Shader")
	file_selected.connect(_on_file_selected)
	
	
	(Engine.get_main_loop() as SceneTree).root.add_child(self)


func _on_file_selected(path: String) -> void:
	var edited_scene_root : Node = (Engine.get_main_loop() as SceneTree).edited_scene_root
	if edited_scene_root:
		_export_scene(path, edited_scene_root)

func _export_scene(target_file: String, scene_root:Node) -> void:
	#var scene_type : ISFConverter.SceneType = options["scene_type"]
	
	var converter := ISFConverter.new()
	var isf_file := converter.convert_scene_to_isf(scene_root)
