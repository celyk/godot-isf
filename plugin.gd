@tool
extends EditorPlugin

const Importer = preload("importer.gd")
var importer_instance := Importer.new()

var export_item_index := -1
func _enter_tree() -> void:
	add_scene_format_importer_plugin(importer_instance)
	
	var export_menu : PopupMenu = get_export_as_menu()
	export_item_index = export_menu.item_count
	export_menu.add_item("ISF Shader...")

func _exit_tree() -> void:
	remove_scene_format_importer_plugin(importer_instance)

	var export_menu : PopupMenu = get_export_as_menu()
	export_menu.remove_item(export_item_index)
