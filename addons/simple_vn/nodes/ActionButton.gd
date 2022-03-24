extends Button

@export_multiline var action := ""

func _init() -> void:
	DialogueStack.started.connect(set_disabled.bind(true))
	DialogueStack.finished.connect(set_disabled.bind(false))

func _pressed() -> void:
	if DialogueStack.can_do(action):
		DialogueStack.do(action)
	else:
		State.do(action)
	
	release_focus()
