@tool
extends Control

func _ready() -> void:
	for child in get_parent_control().get_children():
		if child != self:
			child.resized.connect(_resized)
	_resized()

func _resized():
	var y := 0.0
	var n: Control = get_parent_control()
	for i in range(1, n.get_child_count()-1):
		y += n.get_child(i).size.y
		y += n.get_theme_constant("separation")
	size.y = 0.0
	minimum_size.y = (n.size.y - y) * .5
