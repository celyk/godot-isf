@tool
class_name ISFMaterial extends ShaderMaterial

@export var isf_shader : ShaderInclude :
	set(value):
		isf_shader = value
		_update_shader()

func _validate_property(property: Dictionary) -> void:
	return
	if property.name == "shader":
		property.usage &= ~PROPERTY_USAGE_EDITOR

func _update_shader() -> void:
	if shader == null:
		shader = Shader.new()
	
	var generated_shader : String
	generated_shader += "shader_type canvas_item;\n"
	generated_shader += "#define INCLUDE\n"
	generated_shader += '#include "' + isf_shader.resource_path + '"'
	shader.code = generated_shader
