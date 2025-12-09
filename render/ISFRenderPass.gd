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
	_set_parent_viewport_texture()
	pass

func _validate_state():
	render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.material = material
	#_rect.size = Vector2(1e9,1e9)
	
	_set_parent_viewport_texture.call()
	
	if persistent:
		_setup_gpu_ping_pong()

func _set_parent_viewport_texture():
	if is_inside_tree() and (get_parent().has_method("get_material") or get_parent() is ISFRenderPass):
		#var vp_texture := ViewportTexture.new()
		#var scene_root := self.owner
		print(get_parent().material, " setting vp " , target, " to ", get_parent().name)
		get_parent().material.set_shader_parameter(target, get_texture())
		#vp_texture.viewport_path = get_parent().material.get_local_scene().get_path_to(self)
		#print(vp_texture.viewport_path)

func _setup_gpu_ping_pong() -> void:
	pass
