@tool
extends PointLight2D

@export var animate := true
@export var flicker_min := 0.1
@export var flicker_max := 0.2
@export var time_scale := 1.0

func _process(_delta: float) -> void:
	if animate:
		energy = URand.noise_animated_lerp(flicker_min, flicker_max, position.x, time_scale)
