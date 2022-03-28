@tool
extends Node
class_name SootScene

var id: String:
	get: return UFile.get_file_name(scene_file_path)

var soot_path: String:
	get: return "res://dialogue/%s.soot" % id

func _ready() -> void:
	if not Engine.is_editor_hint():
		State.changed.connect(_property_changed)

func has_soot() -> bool:
	return UFile.file_exists(soot_path)

func _get_tool_buttons():
	if has_soot():
		return [{
			text="Edit %s.soot" % id,
			call="@SELECT_AND_EDIT;%s" % soot_path,
			hint="Edit %s." % soot_path
		}]
	else:
		return [{
			text="Create %s.soot" % id,
			call="@CREATE_AND_EDIT;%s;%s" % [soot_path, "=== START\n\tHello world."],
			hint="Create %s." % soot_path}]

func _start(loaded: bool):
	DialogueStack.execute("%s.INIT" % id)
	
	if not loaded:
		print("Started not loaded ")
		DialogueStack.do("=> %s.START" % id)
	else:
		print("Loaded ", self)

func _property_changed(property: String):
	DialogueStack.execute("%s.CHANGED:%s" % [id, property])
