@tool
extends "res://addons/visual_novel/nodes/ModulateEffects.gd"
class_name Sprite2DAnimations

@export var start_hidden := true

@export var unit := 64

@export var _flip_scale := Vector2.ONE:
	set = set_flip

var _xsign: float:
	get: return sign(_flip_scale.x)
	
@export var current_zoom := 1.0:
	set = set_zoom

@export var current_noise := Vector2.ZERO:
	set = set_noise

@export var current_shake := Vector2.ZERO:
	set = set_shake

@export var current_squish := 0.0:
	set = set_squish

@export var current_shift := Vector2.ZERO:
	set = set_shift

@export var origin := Vector2(0.5, 1.0):
	set = set_origin

@export var seed := URand.v2()

func _get_tool_buttons():
	return super._get_tool_buttons() + [
		[fade_in, fade_out],
		[
			noise,
			{text="Noise Y", call=noise.bind(1, {xscale=0.125, yscale=2.0})},
			{text="Noise X", call=noise.bind(1, {xscale=2.0, yscale=0.125})}
		],
		[noise_in, noise_out, noise_yes, noise_no],
		[shake_in, shake_out, shake_yes, shake_no],
	blink,
	[blink, noise],
	[shift_left, shift_reset, shift_right],
	[fade_in, shift.bind(-1, 0)],
	
	[from_left, from_right, from_bottom, from_top],
	
	flip,
	
	[zoom.bind(.9), zoom, zoom.bind(1.1)],
	[stand, squash, slouch],
	[lean_left, lean_reset, lean_right],
	[rotate.bind(-10), rotate, rotate.bind(10)],
	
	[laugh, sigh, unsigh, talk, dance, suspicious],
	[lean_back, gross],
	
	
	[breath, pant, stop, woozy],
	reset
	
#	trans.bind(preload("res://chars/20170305_concierge-female.png")),
#	trans.bind(preload("res://chars/20191124_man4.png")),
	
	
]

# will prevent dialogue stack from running until all tweens finish.
func wait():
	VisualNovel.wait(self)
	_tween.tween_callback(VisualNovel.unwait.bind(self))

func flip():
	var t := _create()
	_add_flip(t)

func hide():
	modulate.a = 0.0

func show():
	modulate.a = 1.0

func reset():
	squash()
	lean()
	zoom()
	do_rotate()

func from_left(units := 1.0):
	var t := _create()
	modulate = Color.TRANSPARENT
	current_shift = Vector2(unit * -units, 0)
	_add_color(t, Color.WHITE, {ease=Tween.EASE_OUT})
	_add_shift(t, 0, 0, {ease=Tween.EASE_OUT, trans=Tween.TRANS_QUINT})

func from_right(units := 1.0):
	var t := _create()
	modulate = Color.TRANSPARENT
	current_shift = Vector2(unit * units, 0)
	_add_color(t, Color.WHITE, {ease=Tween.EASE_OUT})
	_add_shift(t, 0, 0, {ease=Tween.EASE_OUT, trans=Tween.TRANS_QUINT})

func from_top(units := 1.0):
	var t := _create()
	modulate = Color.TRANSPARENT
	current_shift = Vector2(0, -unit * units)
	_add_color(t, Color.WHITE, {ease=Tween.EASE_OUT})
	_add_shift(t, 0, 0, {ease=Tween.EASE_OUT, trans=Tween.TRANS_QUINT})

func from_bottom(units := 1.0):
	var t := _create()
	modulate = Color.TRANSPARENT
	current_shift = Vector2(0, unit * units)
	_add_color(t, Color.WHITE, {ease=Tween.EASE_OUT})
	_add_shift(t, 0, 0, {ease=Tween.EASE_OUT, trans=Tween.TRANS_QUINT})

func dropped():
	var t := _create()
	modulate = Color.TRANSPARENT
	current_shift = Vector2(0, unit * -6)
	_add_color(t, Color.WHITE, {ease=Tween.EASE_OUT})
	_add_shift(t, 0, 0, {ease=Tween.EASE_OUT, trans=Tween.TRANS_BOUNCE})

func laugh():
	var t := _create()
	_add_shake(t, 0.5, {ytimes=4.0, yscale=0.5})
	_add_rotate(t, -4.0)
	_add_squash(t, -1)
	_add_squash(t.chain())
	_add_rotate(t)

func suspicious():
	var t := _create()
	_add_flip(t, -1)
	t.chain()
#	_add_squash(t, 2.0)
	_add_lean(t, -0.5)
#	t.chain()
##	_add_squash(t, 0.0)
#	_add_lean(t, 0.0)
	
	t.chain()
	_add_flip(t, 1)
	t.chain()
#	_add_squash(t, 2.0)
	_add_lean(t, 0.5)
	t.chain()
#	_add_squash(t, 0.0)
	_add_lean(t, 0.0)
	t.chain()
	_add_flip(t, -1)

func lean_left(): lean(-1)
func lean_right(): lean(1)
func lean_reset(): lean()

func lean_back():
	var t := _create()
	_add_lean(t, 2.0)
	_add_squash(t, 2.0)
	t.chain()
	_add_squash(t, 1.0)

func gross():
	var t := _create()
	_add_shift(t, -4.0, 0.0, {time=0.5})
	_add_lean(t, 2.0 * _xsign, {time=0.5})
	_add_blink(t, Color.TOMATO)
	t.chain()
	_add_shift(t, 0.0, 0.0, {time=0.5})
	_add_lean(t)
	_add_color(t)

func woozy(kwargs := {}):
	var gds: GDScript = get_script()
	var path : = gds.resource_path.get_base_dir()
	path = path.plus_file("sprite_2d_animations").plus_file("woozy.tres")
	var mat = load(path)
	mat.set_shader_param("noise_scale", 0.0)
	var t := _create()
	t.chain()
	t.tween_callback(set_material.bind(mat))
	t.chain()
	t.tween_method(func(x):
		x = 1.0 - abs(x - .5) * 2.0
		x *= x
		mat.set_shader_param("noise_scale", x * 64.0),
		0.0, 1.0, kwargs.get("time", 4.0))
	t.chain()
	t.tween_callback(set_material.bind(null))

#func trans(next: Texture):
#	var mat = load("res://addons/visual_novel/nodes/sprite_2d_animations/trans.tres")
#	mat.set_shader_param("blend", 0.0)
#	mat.set_shader_param("next", next)
#	var t := _create()
#	t.tween_callback(set_material.bind(mat))
#	t.tween_method(func(x):
#		mat.set_shader_param("blend", x),
#		0.0, 1.0, 0.5)
#	t.tween_callback(set_texture.bind(next))
#	t.tween_callback(set_material.bind(null))

func dance(amount := 0.5, kwargs := {}):
	var t := _create()
	_add_lean(t, -amount, kwargs)
	_add_lean(t, amount, kwargs)
	_add_lean(t, -amount, kwargs)
	_add_lean(t, amount, kwargs)
	_add_lean(t, 0, kwargs)

func talk(dir := 1.1):
	var t := _create()
	t.set_parallel()
	_add_squash(t, dir)
	_add_squash(t.chain(), 0.0)

func sigh():
	var t := _create()
	_add_squash(t, -.2, {time=0.25, trans="linear", ease="out"})
	_add_squash(t.chain(), 1.25, {time=2.0})

func unsigh():
	var t := _create()
	_add_squash(t, 0.0, {trans="linear", ease="out"})
	_add_squash(t.chain(), 1.25, {time=2.0})

func noise_in():
	fade_in()
	noise_from()

func noise_out():
	fade_out()
	noise_to()

func noise_yes():
	var t := _create()
	_add_shake(t.chain(), 0.5, {yscale=1.0, ytimes=3, xscale=0.0})
	_add_noise(t, 0.5, 0.0, 1.0, {turb=2})
	_add_blink(t, Color.AQUAMARINE)

func noise_no():
	var t := _create()
	_add_shake(t.chain(), 0.5, {yscale=0.0, xtimes=3, xscale=1.0})
	_add_noise(t, 0.5, 0.0, 1.0, {turb=2})
	_add_blink(t, Color.TOMATO)

func shake_in():
	fade_in()
	_add_shake(_create(), 0.5, {xscale=1.0, off=false, xtimes=4, yscale=0.0})

func shake_out():
	fade_out()
	_add_shake(_create(), 0.5, {xscale=1.0, off=true, xtimes=4, yscale=0.0})

func shake_yes():
	var t := _create()
	_add_shake(t.chain(), 0.5, {yscale=1.0, ytimes=3, xscale=0.0})
	_add_blink(t, Color.AQUAMARINE)

func shake_no():
	var t := _create()
	_add_shake(t.chain(), 0.5, {yscale=0.0, xtimes=3, xscale=1.0})
	_add_blink(t, Color.TOMATO)

func breath():
	var t := _create()
	_add_squash(t, -0.1, {time=1.5, trans=Tween.TRANS_SINE})
	_add_squash(t, 0.5, {time=1.5, trans=Tween.TRANS_SINE})
	t.set_loops(5.0)

func pant(p := 1.0):
	var t := _create()
	_add_squash(t.chain(), -0.25 * p, {ease=Tween.EASE_OUT})
	_add_squash(t.chain(), 0.25 * p, {ease=Tween.EASE_OUT})
	t.set_loops(5)

func stop():
	if _tween:
		_tween.kill()

func noise(power := 1.0, kwargs := {}):
	_add_noise(_create(), power, 0.0, 1.0, kwargs)

func noise_from(power := 1.0, kwargs := {}):
	_add_noise(_create(), power, 0.5, 1.0, kwargs)

func noise_to(power := 1.0, kwargs := {}):
	_add_noise(_create(), power, 0.0, 0.5, kwargs)

func _add_noise(t: Tween, power := 1.0, from := 0.0, to := 1.0, kwargs := {}):
	return t.tween_method(_noise.bind(power, kwargs), from, to, kwargs.get("time", 1.0))\
		.set_trans(UTween.find_trans(kwargs.get("trans", Tween.TRANS_LINEAR)))\
		.set_ease(UTween.find_ease(kwargs.get("ease", Tween.EASE_IN_OUT)))

func _noise(t: float, power: float, kwargs: Dictionary):
	t = 1.0 - absf(t - 0.5) * 2.0
	t *= t # smoothing.
	var n := URand.noise_animated_v2(seed, kwargs.get("turb", 1.0))
	n.x *= kwargs.get("xscale", 1.0) as float
	n.y *= kwargs.get("yscale", 1.0) as float
	n *= kwargs.get("unit", unit) as float
	n *= t * power
	current_noise = n

func shake(power := 1.0, kwargs := {}):
	_add_shake(_create(), power, kwargs)

func _add_shake(t: Tween, power := 1.0, kwargs := {}):
	return t.tween_method(_shake.bind(power, kwargs), 0.0, 1.0, kwargs.get("time", 1.0))\
		.set_trans(Tween.TRANS_SINE)

func _shake(t: float, power: float, kwargs: Dictionary):
	var sh := Vector2.ZERO
	if "off" in kwargs:
		var s := (t if kwargs.off else (1.0-t))
		sh.x = sin(t * kwargs.get("xtimes", 2.0) * -TAU) * s
		sh.y = sin(t * kwargs.get("ytimes", 2.0) * -TAU) * s
	else:
		sh.x = sin(t * kwargs.get("xtimes", 2.0) * -TAU)
		sh.y = sin(t * kwargs.get("ytimes", 2.0) * -TAU)
	sh *= power * unit
	sh.x *= kwargs.get("xscale", 1.0) as float
	sh.y *= kwargs.get("yscale", 0.0) as float
	current_shake = sh

func shift_left(units := 1, kwargs := {}):
	shift(-units, 0, kwargs)

func shift_right(units := 1, kwargs := {}):
	shift(units, 0, kwargs)

func shift_reset(kwargs := {}):
	shift(0, 0, kwargs)

func shift(x := 0.0, y := 0.0, kwargs := {}):
	_add_shift(_create(), x, y, kwargs)

func _add_shift(t: Tween, x := 0.0, y := 0.0, kwargs := {}):
	var v := Vector2(x, y) * (kwargs.get("unit", unit) as float)
	t.tween_property(self, "current_shift", v, kwargs.get("time", 1.0))\
		.set_trans(UTween.find_trans(kwargs.get("trans", Tween.TRANS_BACK)))\
		.set_ease(UTween.find_ease(kwargs.get("ease", Tween.EASE_IN_OUT)))

func zoom(to := 1.0, kwargs := {}):
	var t := _create()
	t.tween_method(set_zoom, current_zoom, to, kwargs.get("time", 1.0))\
		.set_trans(UTween.find_trans(kwargs.get("trans", Tween.TRANS_BACK)))\
		.set_ease(UTween.find_ease(kwargs.get("ease", Tween.EASE_IN_OUT)))
	return t

func stand():
	squash(-1.25)

func slouch():
	squash(1.25)

func squash(x := 0.0, kwargs := {}):
	_add_squash(_create(), x, kwargs)

func _add_squash(t: Tween, x := 0.0, kwargs := {}):
	return t.tween_property(self, "current_squish", x * .05, kwargs.get("time", 1.0))\
		.set_trans(UTween.find_trans(kwargs.get("trans", Tween.TRANS_BACK)))\
		.set_ease(UTween.find_ease(kwargs.get("ease", Tween.EASE_IN_OUT)))

func _add_flip(t: Tween, f: float = _xsign):
	return t.tween_property(self, "_flip_scale:x", f, 0.125)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func lean(l := 0.0, kwargs := {}):
	_add_lean(_create(), l, kwargs)

func _add_lean(t: Tween, l := 0.0, kwargs := {}):
	t.tween_property(self, "skew", l * .1, kwargs.get("time", 1.0))\
		.set_trans(Tween.TRANS_BACK)

func do_rotate(amount := 0.0, kwargs := {}):
	_add_rotate(_create(), amount, kwargs)

func _add_rotate(t: Tween, amount := 0.0, kwargs := {}):
	t.tween_property(self, "rotation", deg2rad(amount), kwargs.get("time", 1.0)).set_trans(Tween.TRANS_BACK)

func set_shake(n: Vector2):
	current_shake = n
	_update_offset()

func set_noise(n: Vector2):
	current_noise = n
	_update_offset()

func set_shift(n: Vector2):
	current_shift = n
	_update_offset()

func set_zoom(z: float):
	current_zoom = z
	_update_scale()

func set_flip(f: Vector2):
	_flip_scale = f
	_update_scale()

func set_origin(o: Vector2):
	origin = o
	_update_offset()

func set_squish(x: float):
	current_squish = x
	_update_scale()
	_update_offset()

func _update_scale():
	var s := current_squish + 1.0
	scale = _flip_scale * Vector2(s, 1.0 / s) * current_zoom

func _update_offset():
	var s = self.texture.get_size()
	position = -origin * s
	position += current_noise
	position += current_shake
	position += current_shift
	if self.centered:
		position += s * .5
