@tool
class_name ISFEffectPlayer2D extends MeshInstance2D

@export var effect : ShaderMaterial :
	set(value):
		effect = value
		
		if not is_inside_tree(): return
		
		_on_effect_changed()

var isf_file : ISFFile

func _init() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	if effect == null || effect.shader == null:
		effect = ShaderMaterial.new()
		effect.shader = Shader.new()
		effect.shader.code = _default_shader_code
	
	scale = Vector2(256,256)
	
	_init_rect()

func _init_rect() -> void:
	material = effect
	mesh = QuadMesh.new()
	mesh.size = Vector2i(2, -2)

func _on_effect_changed() -> void:
	if not (effect and effect.shader): return
	material = effect

func _on_effect_changed0() -> void:
	if not (effect and effect.shader): return
	
	isf_file = ISFFile.open(effect.shader.resource_path)
	
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	var converter := ISFConverter.new()
	var scene_root := converter.convert_isf_to_scene(isf_file, 0, effect.shader)
	#scene_root.mesh = _rect.mesh
	
	if scene_root == null: return
	
	scene_root.material = effect
	
	for child in get_children():
		child.queue_free()
	
	material = effect
	
	#_rect.material = 
	#_rect = scene_root
	#add_child(scene_root)
	
	#_on_size_changed()


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
