extends PatchableData
class_name Character, "res://addons/visual_novel/icons/person.png"
func get_class() -> String:
	return "Character"

var name := ""
var format := ""
var gender := ""
var at := ""
var color := Color.WHITE
var inventory := ""

func _get(property: StringName):
	var k := str(property)
	# TODO: Grammar pronouns
	return super._get(property)

