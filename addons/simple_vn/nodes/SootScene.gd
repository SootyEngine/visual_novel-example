extends Node

func _ready() -> void:
	_ready_deferred.call_deferred()

func _ready_deferred():
	var id := UFile.get_file_name(scene_file_path)
	DialogueStack.do("=> %s.START" % id)
