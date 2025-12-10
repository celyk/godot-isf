@tool
class_name ISFExpression extends RefCounted

var _expression := Expression.new()
var expression_code : String

func parse(expression:String, input_names:=PackedStringArray()) -> void:
	expression_code = expression
	_expression.parse(expression.remove_chars("$"), input_names)

func execute(inputs:=[]) -> Variant:
	return _expression.execute(inputs)
