extends Node

var current_scene := ""
var flow_history := []
var flow_visited := {}
var caption_at := "bottom"
var caption_auto_clear := true
var time := DateTime.new({weekday="sat"})

func caption(kwargs: Dictionary):
	if "at" in kwargs:
		State._set("caption_at", kwargs.at)
	if "clear" in kwargs:
		State._set("caption_auto_clear", kwargs.clear)

