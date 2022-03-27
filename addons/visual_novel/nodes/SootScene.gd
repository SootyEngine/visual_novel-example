extends Node
class_name SootScene

var scene_id: String:
	get: return UFile.get_file_name(scene_file_path)

func _init() -> void:
	State.changed.connect(_property_changed)
	Saver._get_state.connect(_get_save_state)
	Saver._set_state.connect(_set_save_state)

func _get_save_state():
	pass

func _set_save_state():
	pass

func _start(loaded: bool):
	DialogueStack.execute("%s.INIT" % scene_id)
	
	if not loaded:
		print("Started not loaded ")
		DialogueStack.do("=> %s.START" % scene_id)
	else:
		print("Loaded ", self)

func _property_changed(property: String):
	DialogueStack.execute("%s.CHANGED:%s" % [scene_id, property])
