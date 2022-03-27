extends Button

@export var action := ""
@export var condition_visible := ""

func _init() -> void:
	DialogueStack.started.connect(set_disabled.bind(true))
	DialogueStack.ended.connect(set_disabled.bind(false))

func _ready() -> void:
	if len(condition_visible):
		visible = true if State._eval(condition_visible) else false

func _pressed() -> void:
	release_focus()
	
	if DialogueStack.can_do(action):
		DialogueStack.do(action)
	else:
		StringAction.do(action)
