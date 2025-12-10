@tool
class_name ISFEffect extends ShaderMaterial

@export var embedded_shader_include : ShaderInclude

func _init() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	if embedded_shader_include == null:
		embedded_shader_include = ShaderInclude.new()
		embedded_shader_include.code = "#define EPIC"
		
		if resource_path:
			embedded_shader_include.resource_name = resource_path + "::Embedded"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
