@tool
class_name ISFRenderPass extends SubViewport

@export var material : ShaderMaterial :
	set(value):
		material = value
		_validate_state()

@export var persistent := false :
	set(value):
		persistent = value
		_validate_state()

@export var pass_index := 0 :
	set(value):
		pass_index = value
		
		if material:
			_rect.set_instance_shader_parameter("PASSINDEX", pass_index)

@export var target : String

var _rect := ColorRect.new()
func _ready() -> void:
	add_child(_rect)
	
	_validate_state()

func _process(delta: float) -> void:
	# Shouldn't have to do this
	_set_parent_viewport_textures()
	pass

func _validate_state():
	render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.material = material
	#_rect.size = Vector2(1e9,1e9)
	
	_set_parent_viewport_textures.call()
	
	if persistent:
		_setup_gpu_ping_pong()

func _set_parent_viewport_textures():
	if is_inside_tree() and (get_parent().has_method("get_material") or get_parent() is ISFRenderPass):
		print(get_parent().material, " setting vp " , target, " to ", get_parent().name)
		get_parent().material.set_shader_parameter(target, get_texture())
		
		_copy_viewport_textures(material, get_parent().material)

func _copy_viewport_textures(material_a:ShaderMaterial, material_b:ShaderMaterial) -> void:
	var parameters := material_a.shader.get_shader_uniform_list()
	
	for parameter in parameters:
		var value : Variant = material_a.get_shader_parameter(parameter.name)
		if not (value is ViewportTexture): continue
		material_b.set_shader_parameter(parameter.name, value)

func _setup_gpu_ping_pong() -> void:
	pass
