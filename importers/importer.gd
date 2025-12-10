@tool
extends RefCounted

var editor_plugin : EditorPlugin

const SImporter = preload("scene_importer.gd")
const RImporter = preload("resource_importer.gd")
var importer_instance := RImporter.new()

var export_item_index := -1
func initialize(_editor_plugin:EditorPlugin):
	editor_plugin = _editor_plugin
	if importer_instance is ResourceImporter:
		editor_plugin.add_import_plugin.call(importer_instance)
	else:
		editor_plugin.add_scene_format_importer_plugin.call(importer_instance)

func cleanup():
	if importer_instance is ResourceImporter:
		editor_plugin.remove_import_plugin.call(importer_instance)
	else:
		editor_plugin.remove_scene_format_importer_plugin.call(importer_instance)
