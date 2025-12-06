@tool
extends EditorPlugin

const Importer = preload("importer.gd")
var importer_instance := Importer.new()

func _enter_tree() -> void:
	add_import_plugin(importer_instance)

func _exit_tree() -> void:
	remove_import_plugin(importer_instance)
