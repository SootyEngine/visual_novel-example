@tool
extends Node

@export_range(0.0, 8.0) var dist := 2.0:
	set(s):
		dist = s
		$rgb_split.material.set_shader_param("dist", s)

@export_range(0.0, 2.0) var blur := 0.5:
	set(s):
		blur = s
		$rgb_split.material.set_shader_param("blur", s)
