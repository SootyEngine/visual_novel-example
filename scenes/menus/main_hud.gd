extends Control

var _tween: Tween

func _ready() -> void:
	DialogueStack.started.connect(_hide)
	DialogueStack.ended.connect(_show)
	if DialogueStack.is_active():
		modulate.a = 0.0

func _init_tween():
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.bind_node(self)
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

func _hide():
	_init_tween()
	_tween.tween_property(self, "modulate:a", 0.0, 0.25)
	_tween.tween_callback(set_visible.bind(false))

func _show():
	_init_tween()
	_tween.tween_callback(set_visible.bind(true))
	_tween.tween_property(self, "modulate:a", 1.0, 0.25)
