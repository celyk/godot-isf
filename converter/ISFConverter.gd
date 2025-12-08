@tool
class_name ISFConverter extends RefCounted

enum SceneType {CONTROL, NODE_2D, NODE_3D}

## Convert and generates the scene structure
func convert_isf_to_scene(isf_file:ISFFile, scene_type:int=0) -> Node:
	var scene_root := Node.new()
	
	match scene_type:
		SceneType.CONTROL:
			scene_root = ColorRect.new()
		SceneType.NODE_2D:
			scene_root = MeshInstance2D.new()
		SceneType.NODE_3D:
			scene_root = MeshInstance3D.new()
		_:
			return scene_root
	
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	var material : ShaderMaterial =  parser.material
	material.resource_local_to_scene = true
	
	# Inititalize multi passes
	var pass_parent : Node = scene_root
	for i in range(parser.passes.size()-1, -1, -1):
		var buffer_info := parser.passes[i]
		
		var vp := ISFRenderPass.new()
		vp.material = material
		vp.name = buffer_info.target.to_pascal_case()
		vp.persistent = buffer_info.persistent
		vp.target = buffer_info.target
		vp.pass_index = parser.passes.size()-1 - i
		pass_parent.add_child(vp, true)
		vp.owner = scene_root
		
		pass_parent = vp
	
	# Initialize shader parameters
	for info in parser.inputs:
		material.set_shader_parameter(info.name, info.default_value)
	
	for info in parser.imported_images:
		material.set_shader_parameter(info.target, info.texture)
	
	var mesh := QuadMesh.new()
	
	match scene_type:
		SceneType.CONTROL:
			scene_root.set_anchors_preset(Control.PRESET_FULL_RECT)
			scene_root.material = material
		SceneType.NODE_2D:
			scene_root.mesh = mesh
			scene_root.material = material
			mesh.size = Vector2(1280, 720)
		SceneType.NODE_3D:
			scene_root.mesh = mesh
			scene_root.material_override = material
	
	material.set_shader_parameter(scene_root.get_child(0).target, scene_root.get_child(0).get_texture())
	scene_root.set_instance_shader_parameter("PASSINDEX", parser.passes.size())
	
	return scene_root

func convert_scene_to_isf(scene_root:Node) -> ISFFile:
	var isf_file := ISFFile.new()
	
	var parser := ISFParser.new()
	#parser.parse(isf_file)
	
	return ISFFile.new()
