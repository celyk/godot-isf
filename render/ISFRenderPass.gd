@tool
class_name ISFRenderPass extends SubViewport

var persistent := false

func _ready() -> void:
	render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
