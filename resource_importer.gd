@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "ISFImporter"

func _get_visible_name() -> String:
	return "ISF Importer"

func _get_recognized_extensions() -> PackedStringArray:
	return ["fs", "isf"]

func _get_save_extension() -> String:
	return "tscn"

func _get_resource_type() -> String:
	return "PackedScene"

func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return []

func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var path_to_save : String = save_path + '.' + _get_save_extension()
	var additional_folder := path_to_save.get_base_dir().path_join( str(save_path.get_file().hash()) )
	#additional_folder = path_to_save.get_basename()
	
	print("Hash: ", str(save_path.get_file().hash()) )
	
	#var scene_type : ISFConverter.SceneType = options["scene_type"]
	
	var converter := ISFConverter.new()
	var isf_file := ISFFile.open(source_file)
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	var scene_root := converter.convert_isf_to_scene(isf_file)
	
	var include_path := additional_folder.path_join("generated_inputs.gdshaderinc")
	var include : ShaderInclude = _load_or_create_resource(include_path, ShaderInclude.new())
	var shader_path := additional_folder.path_join("generated_shader.gdshader")
	var shader : Shader = _load_or_create_resource(shader_path, Shader.new())
	
	if include == null: return Error.ERR_CANT_ACQUIRE_RESOURCE
	
	var include_code := _generate_include_code(isf_file)
	include.code = include_code
	
	var shader_code : String = _generate_shader_code(isf_file)
	shader.code = shader_code
	
	scene_root.material.shader = shader
	
	#
	#var file := FileAccess.open(include_path, FileAccess.WRITE)
	#file.store_string(include.code)
	#file.flush()
	#
	#file = FileAccess.open(shader_path, FileAccess.WRITE)
	#file.store_string(shader.code)
	#file.flush()
	
	var err := ResourceSaver.save(include, include_path, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	#print(err)
	
	err = ResourceSaver.save(shader, shader_path, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	print(shader_path)
	
	include.emit_changed()
	shader.emit_changed()
	
	var scene := PackedScene.new()
	scene.pack(scene_root)
	
	return ResourceSaver.save(scene, path_to_save, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)

func _generate_include_code(isf_file:ISFFile) -> String:
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	var include_code := "\n"
	
	include_code += parser.generate_shader_uniform_declarations() + "\n\n"
	include_code += '#include "res://addons/godot-isf/include/ISF.gdshaderinc"\n\n'
	
	return include_code

func _generate_shader_code(isf_file:ISFFile) -> String:
	var shader_code : String = "/*\n" + JSON.stringify(isf_file.json.data, "\t") + "\n*/\n\n"
	shader_code += "shader_type canvas_item;\n\n"
	shader_code += '#include "generated_inputs.gdshaderinc"\n\n'
	#shader_code += '#include "res://addons/godot-isf/include/ISF.gdshaderinc"\n\n'
	shader_code += isf_file.shader_source
	
	return shader_code

func _load_or_create_resource(path:String, instance:Resource) -> Resource:
	DirAccess.make_dir_absolute(path.get_base_dir())
	EditorInterface.get_resource_filesystem().update_file(path.get_base_dir())
	#instance.resource_path = path
	instance.take_over_path(path)
	return instance
	
	#EditorInterface.get_resource_filesystem().scan()
	
	#var dir := DirAccess.open("res://")
	print(path)
	if ResourceLoader.exists(path):
		print(path, " exists")
		var res := ResourceLoader.load(path)#, "", ResourceLoader.CACHE_MODE_REPLACE_DEEP)
		return res
	#
	var res : Resource = instance
	res.resource_path = path
	
	print(res)
	#if ResourceSaver.save(res, path, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS) != OK:
		#return null
	
	#
	#var err := ResourceSaver.save(res, path)
	#if err != OK:
		#print(err)
		#return null
	
	return res
