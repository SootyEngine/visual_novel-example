@tool
extends Node

@export var size := 512.0:
	set(s):
		size = s
		$noise.material.set_shader_param("size", size)

@export_range(0.0, 2.0) var lum_scale := 0.75:
	set(s):
		lum_scale = s
		$noise.material.set_shader_param("lum_scale", lum_scale)
