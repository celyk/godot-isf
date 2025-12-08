@tool
extends EditorPlugin

#const SImporter = preload("scene_importer.gd")
const RImporter = preload("resource_importer.gd")

var importer_instance := RImporter.new()

const Exporter = preload("exporter.gd")
var exporter_instance := Exporter.new()


var export_item_index := -1
func _enter_tree() -> void:
	if importer_instance is ResourceImporter:
		add_import_plugin.call(importer_instance)
	else:
		add_scene_format_importer_plugin.call(importer_instance)
	
	# Add an option to the export menu
	var export_menu : PopupMenu = get_export_as_menu()
	export_item_index = export_menu.item_count
	export_menu.add_item("ISF Shader...")
	export_menu.set_item_metadata(export_item_index, _export_isf)

func _exit_tree() -> void:
	if importer_instance is ResourceImporter:
		remove_import_plugin.call(importer_instance)
	else:
		remove_scene_format_importer_plugin.call(importer_instance)
	
	# Remove the option from the export menu
	var export_menu : PopupMenu = get_export_as_menu()
	export_menu.remove_item(export_item_index)


func _export_isf() -> void:
	exporter_instance.export()
