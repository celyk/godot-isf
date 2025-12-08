@tool
class_name ISFShader extends ShaderInclude

## Custom shader type to implement ISF shaders

#@export var isf_code : String


func _validate_property(property: Dictionary) -> void:
	if property.name == "code":
		property.usage &= ~PROPERTY_USAGE_EDITOR
