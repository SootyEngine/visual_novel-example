extends Button

@export_multiline var command := ""

func _init() -> void:
	DialogueStack.started.connect(set_disabled.bind(true))
	DialogueStack.finished.connect(set_disabled.bind(false))

func _pressed() -> void:
	if DialogueStack.can_do(command):
		DialogueStack.do(command)
	else:
		State.do(command)
	
	release_focus()
