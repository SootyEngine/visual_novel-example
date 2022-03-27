@tool
extends Node

@export_range(0.0, 1.0) var blend := 1.0:
	set(b):
		blend = b
		$ColorRect.material.set_shader_param("blend", b)

@export var default_fade_time := 0.125

var _tween: Tween

func _get_tool_buttons():
	return [fade_out, fade_in]

func fade_in(time := default_fade_time):
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "blend", 1.0, time)

func fade_out(time := default_fade_time):
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "blend", 0.0, time)
