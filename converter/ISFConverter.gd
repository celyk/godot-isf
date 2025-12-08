@tool
class_name ISFConverter extends RefCounted

func convert_isf_to_scene(file:ISFFile, type:int=0) -> Node:
	var scene_root := Node.new()
	
	var loader := ISFLoader.create(source_file)
	var material : ShaderMaterial =  loader.compile_shader()
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
	
	return Node.new()

func convert_scene_to_isf() -> ISFFile:
	return ISFFile.new()
