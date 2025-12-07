class_name ISFLoader extends RefCounted

var file : FileAccess
var vertex_shader_source : String
var fragment_shader_source : String
var json := {}

func _init() -> void:
	pass

func create(path:String) -> ISFLoader:
	file = FileAccess.open(path, FileAccess.READ)
	
	fragment_shader_source = file.get_as_text()
	
	return ISFLoader.new()

func compile_shader(shader_type:=0) -> ShaderMaterial:
	return preload("uid://cmagfpnocdt2s")
