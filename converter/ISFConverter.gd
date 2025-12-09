@tool
class_name ISFConverter extends RefCounted

enum SceneType {CONTROL, NODE_2D, NODE_3D}

## Convert and generates the scene structure
func convert_isf_to_scene(isf_file:ISFFile, scene_type:SceneType=0) -> Node:
	var scene_root := Node.new()
	
	var parser := ISFParser.new()
	parser.parse(isf_file)
	
	match scene_type:
		SceneType.CONTROL:
			scene_root = ColorRect.new()
		SceneType.NODE_2D:
			scene_root = MeshInstance2D.new()
		SceneType.NODE_3D:
			scene_root = MeshInstance3D.new()
		_:
			return scene_root
	
	var material : ShaderMaterial =  parser.material
	material.resource_local_to_scene = true
	
	scene_root.material = material
	
	
	
	print(scene_root,  scene_root.material)
	
	var processor_script := ISFProcessorScript.new()
	scene_root.add_child(processor_script, true)
	processor_script.owner = scene_root
	
	# Initialize shader parameters
	for info in parser.inputs:
		material.set_shader_parameter(info.name, info.default_value)
	
	for info in parser.imported_images:
		material.set_shader_parameter(info.target, info.texture)
	
	# Inititalize multi passes
	var pass_parent : Node = scene_root
	for i in range(parser.passes.size()-1, -1, -1):
		var pass_index := i
		var buffer_info := parser.passes[pass_index]
		
		var vp := ISFRenderPass.new()
		vp.material = material.duplicate()
		vp.name = buffer_info.target.to_pascal_case()
		vp.persistent = buffer_info.persistent
		vp.target = buffer_info.target
		vp.pass_index = pass_index #parser.passes.size()-1 - i
		vp.size = Vector2i(buffer_info.width, buffer_info.height)
		pass_parent.add_child(vp, true)
		vp.owner = scene_root
		
		var vp_texture := ViewportTexture.new()
		vp_texture.viewport_path = scene_root.get_path_to(vp)
		print(vp_texture.viewport_path)
		pass_parent.material.set_shader_parameter(vp.target, vp_texture)
		
		pass_parent = vp
	
	scene_root.set_instance_shader_parameter("PASSINDEX", parser.passes.size())
	
	var mesh := QuadMesh.new()
	
	match scene_type:
		SceneType.CONTROL:
			scene_root.set_anchors_preset(Control.PRESET_FULL_RECT)
			scene_root.material = material
			scene_root.size = Vector2(1280, 720)
		SceneType.NODE_2D:
			scene_root.mesh = mesh
			scene_root.material = material
			mesh.size = Vector2(1280, 720)
		SceneType.NODE_3D:
			scene_root.mesh = mesh
			scene_root.material_override = material
	
	scene_root.name = isf_file.path.get_file().get_basename().to_pascal_case()
	
	return scene_root

func convert_scene_to_isf(scene_root:Node) -> ISFFile:
	var isf_file := ISFFile.new()
	
	var parser := ISFParser.new()
	parser.version = "2.0"
	parser.credit = "John Godot"
	
	var shader : Shader = _get_shader_from_scene_root(scene_root)
	
	print(shader.get_shader_uniform_list())
	for uniform in shader.get_shader_uniform_list():
		match uniform.type:
			TYPE_OBJECT:
				var buffer_info := ISFParser.BufferInfo.new()
				parser.passes.append(buffer_info)
			_:
				var input_info := ISFParser.InputInfo.new()
				parser.inputs.append(input_info)
	
	isf_file.json = parser.generate_json()
	isf_file.shader_source = shader.code
	
	var fstart : int = parser.find_function(isf_file.shader_source, "main")
	isf_file.shader_source = isf_file.shader_source.substr(fstart)
	
	return isf_file

func _get_material_from_scene_root(scene_root:Node) -> ShaderMaterial:
	if scene_root is Control:
		return scene_root.material
	if scene_root is Node2D:
		return scene_root.material
	if scene_root is Node3D:
		return scene_root.material_override
	
	return null
	
func _get_shader_from_scene_root(scene_root:Node) -> Shader:
	var material := _get_material_from_scene_root(scene_root)
	if not (material and material.shader): return null
	return material.shader
