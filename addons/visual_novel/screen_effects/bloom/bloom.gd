@tool
extends "res://addons/visual_novel/screen_effects/screen_effect.gd"

@export var default_time = 3.0

@export var size := 3.0:
	set(v):
		size = v
		$ColorRect.material.set_shader_param("size", size)

@export_range(0.0, 1.0) var amount := 0.5:
	set(v):
		amount = v
		$ColorRect.material.set_shader_param("amount", amount)

func _init():
	add_to_group("bloom")

func _get_tool_buttons():
	return [from_white, to_white, pulse, bloom, unbloom]

func to_white(time := default_time):
	_create_tween().tween_property(self, "amount", 1.0, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func from_white(time := default_time):
	_create_tween().tween_property(self, "amount", 0.0, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func bloom(amount := .25, time := default_time):
	_create_tween().tween_property(self, "amount", amount, time)

func unbloom(time := default_time):
	_create_tween().tween_property(self, "amount", 0.0, time)

func pulse(time := default_time):
	var t := _create_tween()
	t.tween_property(self, "amount", 0.25, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(self, "amount", 0.125, 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
