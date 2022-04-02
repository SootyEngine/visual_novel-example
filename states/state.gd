extends Node

var beach_is_night := false
var save_caption := "The Quest"

var score := 0

var godot := Character.new({name="Godot", color=Color.DEEP_SKY_BLUE})
var godette := Character.new({name="Godette", color=Color.SKY_BLUE})
var godot_game_engine := Character.new({name="Godot Game Engine", color=Color.DEEP_SKY_BLUE})

var sooty := Character.new({name="Sooty", color=Color.DARK_GRAY})

var mr_bool := Character.new({name="Mr. Bool", color=Color.BURLYWOOD})

var chris := Character.new({name="Chris", color=Color.DEEP_SKY_BLUE})
var paul := Character.new({name="Paul", color=Color.GREEN_YELLOW})
var john := Character.new({name="John", color=Color.TOMATO})

#func _init() -> void:
#	Saver._get_state_info.connect(_get_state_info)
#
#func _get_state_info(d: Dictionary):
#	d.caption = save_caption
