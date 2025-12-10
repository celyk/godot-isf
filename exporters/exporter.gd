@tool
extends RefCounted

var editor_plugin : EditorPlugin

const Exporter = preload("exporter_file_dialogue.gd")
var exporter_instance := Exporter.new()

var export_item_index := -1
func initialize(_editor_plugin:EditorPlugin):
	editor_plugin = _editor_plugin
	
	# Add an option to the export menu
	var export_menu : PopupMenu = editor_plugin.get_export_as_menu()
	export_item_index = export_menu.item_count
	export_menu.add_item("ISF Shader...")
	export_menu.set_item_metadata(export_item_index, _export_isf)

func cleanup():
	pass

func _export_isf() -> void:
	exporter_instance.export()
