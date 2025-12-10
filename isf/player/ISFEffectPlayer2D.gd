@tool
class_name ISFEffectPlayer2D extends Node2D

@export var shader : Shader

func _init() -> void:
	_initialize.call_deferred()

var _rect := MeshInstance2D.new()
func _initialize() -> void:
	if shader == null:
		shader = Shader.new()
		shader.code = _default_shader_code
	
	_rect.material = ShaderMaterial.new()
	_rect.material.shader = shader
	
	_rect.mesh = QuadMesh.new()
	_rect.mesh.size = Vector2i(512, 512)
	
	add_child(_rect)

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
