@tool
extends "res://addons/simple_vn/screen_effects/screen_effect.gd"

@export var default_time = 0.5

@export var saturation := 1.0:
	set(s):
		saturation = s
		$ColorRect.material.set_shader_param("saturation", saturation)

func _get_tool_buttons():
	return [to_gray, to_color, to_color2, to_color4]

func to_color(time := default_time):
	_create_tween().tween_property(self, "saturation", 1.0, time)

func to_color2(time := default_time):
	_create_tween().tween_property(self, "saturation", 2.0, time)

func to_color4(time := default_time):
	_create_tween().tween_property(self, "saturation", 4.0, time)

func to_gray(time := default_time):
	_create_tween().tween_property(self, "saturation", 0.0, time)
