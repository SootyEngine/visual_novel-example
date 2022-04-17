extends PatchableData
class_name Location, "res://addons/visual_novel/icons/location.png"
func get_class() -> String:
	return "Location"

@export var name := ""
@export var parent := ""
@export var format := ""
@export var color := Color.WHITE
