@tool
extends EditorPlugin

const Importer = preload("importer.gd")
var importer_instance := Importer.new()

const Exporter = preload("exporter.gd")
var exporter_instance := Exporter.new()


var export_item_index := -1
func _enter_tree() -> void:
	add_scene_format_importer_plugin(importer_instance)
	
	# Add an option to the export menu
	var export_menu : PopupMenu = get_export_as_menu()
	export_item_index = export_menu.item_count
	export_menu.add_item("ISF Shader...")
	export_menu.set_item_metadata(export_item_index, _export_isf)

func _exit_tree() -> void:
	remove_scene_format_importer_plugin(importer_instance)

	# Remove the option from the export menu
	var export_menu : PopupMenu = get_export_as_menu()
	export_menu.remove_item(export_item_index)


func _export_isf() -> void:
	exporter_instance.export()
