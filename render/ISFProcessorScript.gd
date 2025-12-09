@tool
class_name ISFProcessorScript extends Node

func _init() -> void:
	name = "ISFProcessorScript"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_update_shader_parameters()

func _update_shader_parameters(root:Node=null) -> void:
	if root == null:
		root = get_parent()
	
	for child in root.get_children():
		if child is ISFRenderPass:
			_copy_shader_parameters(_get_parent_material(), child.material)
			_update_shader_parameters(child)

func _copy_shader_parameters(material_a:ShaderMaterial, material_b:ShaderMaterial) -> void:
	var parameters := material_a.shader.get_shader_uniform_list()
	
	for parameter in parameters:
		var value : Variant = material_a.get_shader_parameter(parameter.name)
		if value is ViewportTexture: continue
		material_b.set_shader_parameter(parameter.name, value)

func _get_parent_material() -> ShaderMaterial:
	return get_parent().material
