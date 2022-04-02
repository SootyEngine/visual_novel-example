extends BaseButton

const FADEOUT_TIME := 0.25

@export var goto_scene_flow := ""
@export var action := ""
@export var condition_visible := ""
@export var fadeout_on_diabled := false
var _tween: Tween

func _init() -> void:
	DialogueStack.started.connect(_disable)
	DialogueStack.ended.connect(_enable)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _disable():
	set_disabled(true)
	if fadeout_on_diabled:
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.bind_node(self)
		_tween.tween_property(self, "modulate:a", 0.0, FADEOUT_TIME)

func _enable():
	set_disabled(false)
	if fadeout_on_diabled:
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.bind_node(self)
		_tween.tween_property(self, "modulate:a", 1.0, FADEOUT_TIME)

func _ready() -> void:
	if len(condition_visible):
		visible = true if State._eval(condition_visible) else false

func _pressed() -> void:
	release_focus()
	
	if DialogueStack.can_do(action):
		DialogueStack.do(action)
	else:
		StringAction.do(action)
	
	if goto_scene_flow:
		DialogueStack.do("=> %s.%s" % [Scene.id, goto_scene_flow])
