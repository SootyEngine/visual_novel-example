extends Node
class_name SootScene

var scene_id: String:
	get: return UFile.get_file_name(scene_file_path)

func _init() -> void:
	State.changed.connect(_property_changed)

func _start(loaded: bool):
	DialogueStack.execute("%s.INIT" % scene_id)
	
	if not loaded:
		DialogueStack.do("=> %s.START" % scene_id)

func _property_changed(property: String):
	DialogueStack.execute("%s.CHANGED:%s" % [scene_id, property])
