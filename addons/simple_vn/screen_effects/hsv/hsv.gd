@tool
extends Node

@export var saturation := 1.0:
	set(s):
		saturation = s
		$ColorRect.material.set_shader_param("saturation", saturation)

@export var default_time = 0.5

func _get_tool_buttons():
	return [to_gray, to_color, to_color2, to_color4]

var _tween: Tween
func _create_tween():
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	return _tween

func to_color(time := default_time):
	_create_tween().tween_property(self, "saturation", 1.0, time)

func to_color2(time := default_time):
	_create_tween().tween_property(self, "saturation", 2.0, time)

func to_color4(time := default_time):
	_create_tween().tween_property(self, "saturation", 4.0, time)

func to_gray(time := default_time):
	_create_tween().tween_property(self, "saturation", 0.0, time)
