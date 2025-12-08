@tool
class_name ISFConverter extends RefCounted

enum SceneType {CONTROL, NODE_2D, NODE_3D}

func convert_isf_to_scene(isf_file:ISFFile, scene_type:int=0) -> Node:
	var scene_root := Node.new()
	
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	# Inititalize multi passes
	for buffer in parser.buffers:
		var vp := SubViewport.new()
		scene_root.add_child(vp)
	
	
	var material : ShaderMaterial =  parser.material
	material.resource_local_to_scene = true
	
	var mesh := QuadMesh.new()
	
	match scene_type:
		SceneType.CONTROL:
			scene_root = ColorRect.new()
			scene_root.set_anchors_preset(Control.PRESET_FULL_RECT)
			scene_root.material = material
		SceneType.NODE_2D:
			scene_root = MeshInstance2D.new()
			scene_root.mesh = mesh
			scene_root.material = material
			mesh.size = Vector2(1280, 720)
		SceneType.NODE_3D:
			scene_root = MeshInstance3D.new()
			scene_root.mesh = mesh
			scene_root.material_override = material
	#
	return scene_root

func convert_scene_to_isf() -> ISFFile:
	var isf_file := ISFFile.new()
	
	var parser := ISFParser.new()
	#parser.parse(isf_file)
	
	return ISFFile.new()
