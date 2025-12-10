@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "ISFImporter"

func _get_visible_name() -> String:
	return "ISF Importer"

func _get_recognized_extensions() -> PackedStringArray:
	return ["fs", "isf"]

func _get_save_extension() -> String:
	return "gdshader"

func _get_resource_type() -> String:
	return "Shader"

func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return []

func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var path_to_save : String = save_path + '.' + _get_save_extension()
	
	var hash := str(path_to_save.get_file().hash())
	var additional_folder := path_to_save.get_base_dir().path_join("ISF").path_join(hash)
	print(additional_folder)
	print(DirAccess.make_dir_absolute(additional_folder.get_base_dir()))
	print(DirAccess.make_dir_absolute(additional_folder))
	
	var converter := ISFConverter.new()
	var isf_file := ISFFile.open(source_file)
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	var include := ShaderInclude.new()
	include.code = _generate_include_code(isf_file)
	print(additional_folder.path_join("generated_inputs.gdshaderinc"))
	ResourceSaver.save(include, additional_folder.path_join("generated_inputs.gdshaderinc"))
	
	var shader := Shader.new()
	shader.code = _generate_shader_code(isf_file, hash)
	ResourceSaver.save(shader, path_to_save)
	
	return OK

func _generate_include_code(isf_file:ISFFile) -> String:
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	var include_code := "\n"
	
	include_code += parser.generate_shader_uniform_declarations() + "\n\n"
	include_code += '#include "res://addons/godot-isf/isf/include/ISF.gdshaderinc"\n\n'
	
	return include_code

func _generate_shader_code(isf_file:ISFFile, hash:String) -> String:
	var shader_code : String = "/*\n" + JSON.stringify(isf_file.json.data, "\t") + "\n*/\n\n"
	shader_code += "shader_type canvas_item;\n\n"
	shader_code += '#include "res://.godot/imported/ISF/%s/generated_inputs.gdshaderinc"\n\n' % [hash]
	#shader_code += '#include "res://addons/godot-isf/include/ISF.gdshaderinc"\n\n'
	shader_code += isf_file.shader_source
	
	return shader_code
