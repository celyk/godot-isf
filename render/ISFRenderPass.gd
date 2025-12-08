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
	pass

func _validate_state():
	render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	#_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.material = material
	_rect.size = Vector2(1e9,1e9)
	
	if persistent:
		_setup_gpu_ping_pong()

func _setup_gpu_ping_pong() -> void:
	pass
