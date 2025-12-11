@tool
class_name ISFEffectPlayerControl extends Control

@export var effect : ShaderMaterial :
	set(value):
		effect = value
		
		if not is_inside_tree(): return
		
		_on_effect_changed()

func _init() -> void:
	_initialize.call_deferred()

var _rect : ISFEffectPlayer2D
func _initialize() -> void:
	if effect == null:
		effect = ShaderMaterial.new()
		effect.shader = Shader.new()
		effect.shader.code = _default_shader_code
	
	_init_rect()

func _process(delta: float) -> void:
	#var shader_material := ShaderMaterial.new()
	#shader_material.shader = shader
	#print(shader_material.get_property_list())
	pass

func _init_rect() -> void:
	_rect = ISFEffectPlayer2D.new()
	add_child(_rect)
	
	_on_effect_changed()
	
	_on_size_changed()
	resized.connect(_on_size_changed)

func _on_size_changed() -> void:
	if _rect:
		_rect.scale = size / 2
		_rect.scale.y = -_rect.scale.y
		_rect.position = size / 2

func _on_effect_changed() -> void:
	_rect.effect = effect


#func _get_effect_file() -> ISFFile:

const _default_shader_code := '''
/*
*/

shader_type canvas_item;
#include "res://addons/godot-isf/isf/include/ISF.gdshaderinc"

void main(){
	// Normalized pixel coordinates (from 0 to 1)
    vec2 uv = isf_FragNormCoord;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(TIME+uv.xyx+vec3(0,2,4));

    // Output to screen
    gl_FragColor = vec4(col,1.0);
}
'''
