@tool
class_name ISFExpression extends RefCounted

var _expression := Expression.new()

func parse(expression:String, input_names:=PackedStringArray()) -> void:
	_expression.parse(expression.remove_chars("$"), input_names)

func execute(inputs:=[]) -> Variant:
	return _expression.execute(inputs)
