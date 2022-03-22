@tool
extends Node2D

func _get_tool_buttons():
	return [
		v_2,
		s_2,
		reset_v,
		reset_s
	]

func v_2():
	modulate.v *= 1.1

func s_2():
	modulate.s += 0.1

func reset_v():
	modulate.v = 1.0

func reset_s():
	modulate = Color.WHITE
