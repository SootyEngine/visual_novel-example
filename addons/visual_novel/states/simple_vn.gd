extends Node

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

func stutter(x):
	var parts := str(x).split(" ")
	for i in len(parts):
		if len(parts[i]) > 2:
			parts[i] = parts[i].substr(0, 1 if randf()>.5 else 2) + "-" + parts[i].to_lower()
	return " ".join(parts)
