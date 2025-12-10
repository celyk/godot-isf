@tool
extends EditorPlugin

const RImporter = preload("importers/importer.gd")
var importer_instance := RImporter.new()

const Exporter = preload("exporters/exporter.gd")
var exporter_instance := Exporter.new()


func _enter_tree() -> void:
	importer_instance.initialize(self)
	exporter_instance.initialize(self)

func _exit_tree() -> void:
	importer_instance.cleanup()
	exporter_instance.cleanup()
