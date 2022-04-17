extends "res://addons/visual_novel/nodes/base_effects.gd"

func _get_tool_buttons() -> Array:
	return [
		[white_in, black_in, radiate]
	]


func _add_color(t: Tween, c := Color.WHITE, kwargs := {}):
	t.tween_property(self, "modulate", c, kwargs.get("time", 1.0))\
		.set_trans(UTween.find_trans(kwargs.get("trans", Tween.TRANS_LINEAR)))\
		.set_ease(UTween.find_ease(kwargs.get("ease", Tween.EASE_IN_OUT)))

func radiate():
	var t := _create()
	t.tween_property(self, "modulate:g", 1.0, 0.5).from(100.0)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)

func fade_in():
	var t := _create()
	modulate = Color.TRANSPARENT
	_add_color(t, Color.WHITE)

func fade_out():
	var t := _create()
	_add_color(t, Color.TRANSPARENT)

func white_in(kwargs := {}):
	var t := _create()
	var clr = UStringConvert.to_color(kwargs.get("color", "white"))
	clr.r *= 200.0
	clr.g *= 200.0
	clr.b *= 200.0
	t.tween_property(self, "modulate", Color.WHITE, 0.5).from(clr)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)

func black_in(kwargs := {}):
	var t := _create()
	t.tween_property(self, "modulate", Color.WHITE, kwargs.get("time", 1.0)).from(Color.BLACK)#\
#		.set_trans(Tween.TRANS_EXPO)\
#		.set_ease(Tween.EASE_OUT)

func blink(color: Variant = Color.TOMATO, kwargs := {}):
	_add_blink(_create(), color, kwargs)

func _add_blink(t: Tween, color: Variant = Color.TOMATO, kwargs := {}):
	t.tween_method(_blink.bind(color, kwargs), 0.0, 1.0, kwargs.get("time", 1.0))

func _blink(t: float, color: Color, kwargs: Dictionary):
	modulate = Color.WHITE.lerp(color, pingpong(t * kwargs.get("count", 1.0) * 2.0, 1.0))
