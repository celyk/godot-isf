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
	
	# Inititalize multi passes
	for buffer in parser.passes:
		var vp := SubViewport.new()
		vp.name = buffer.target.to_pascal_case()
		scene_root.add_child(vp, true)
		vp.owner = scene_root
	
	# Inititalize persistent buffers
	for buffer in parser.persistent_buffers:
		var vp := SubViewport.new()
		vp.name = buffer.target.to_pascal_case()
		scene_root.add_child(vp, true)
		vp.owner = scene_root
	
	
	var material : ShaderMaterial =  parser.material
	material.resource_local_to_scene = true
	
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
	
	return scene_root

func convert_scene_to_isf() -> ISFFile:
	var isf_file := ISFFile.new()
	
	var parser := ISFParser.new()
	#parser.parse(isf_file)
	
	return ISFFile.new()
