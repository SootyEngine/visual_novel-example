extends Button
class_name SceneActionButton

@export var flow := ""

func _init() -> void:
	DialogueStack.started.connect(set_disabled.bind(true))
	DialogueStack.finished.connect(set_disabled.bind(false))

func _pressed() -> void:
	if not len(flow):
		push_warning("No flow given for %s." % self)
		return
	
	var scene_id := UFile.get_file_name(get_tree().current_scene.scene_file_path)
	var flow_id := "%s.%s" % [scene_id, flow]
	if not DialogueStack.has(flow_id):
		push_error("No flow %s." % flow_id)
		return
	
	DialogueStack.goto(flow_id, DialogueStack.STEP_GOTO)
	release_focus()
