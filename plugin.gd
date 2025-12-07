@tool
extends EditorPlugin

const Importer = preload("importer.gd")
var importer_instance := Importer.new()

func _enter_tree() -> void:
	add_scene_format_importer_plugin(importer_instance)

func _exit_tree() -> void:
	remove_scene_format_importer_plugin(importer_instance)
