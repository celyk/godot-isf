extends EditorFileDialog

func _init() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	add_filter("*.fs", "ISF Fragment Shader")
	(Engine.get_main_loop() as SceneTree).root.add_child(self)

func export() -> void:
	popup_file_dialog()
