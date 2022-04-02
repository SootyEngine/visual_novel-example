@tool
extends Node
class_name SootScene

var id: String:
	get: return UFile.get_file_name(scene_file_path)

func _ready() -> void:
	if not Engine.is_editor_hint():
		State.changed.connect(_property_changed)

func has_soot() -> bool:
	return UFile.file_exists_in_dir("res://dialogue", "%s.soot" % id)

func get_soot_path() -> String:
	return UFile.get_file_in_dir("res://dialogue", "%s.soot" % id)

func _start(loaded: bool):
	DialogueStack.execute("%s.INIT" % id)
	
	if not loaded:
		DialogueStack.do("=> %s.START" % id)

func _property_changed(property: String):
	DialogueStack.execute(DialogueStack.join_path([id, "CHANGED:%s" % property]))

func _get_tool_buttons():
	if has_soot():
		var soot_path := get_soot_path()
		return [{
			text="Edit %s.soot" % id,
			call="@SELECT_AND_EDIT;%s" % soot_path,
			hint="Edit %s." % soot_path
		}]
	else:
		var soot_path := "res://dialogue/%s.soot" % id
		var soot_data := "=== START\n\tHello world.\t\nStarted %s." % id.capitalize()
		return [{
			text="Create %s.soot" % id,
			call="@CREATE_AND_EDIT;%s;%s" % [soot_path, soot_data],
			hint="Create %s." % soot_path}]
