extends Control

const FADEOUT_TIME := 0.25

var _tween: Tween

func _init() -> void:
	DialogueStack.started.connect(_disable)
	DialogueStack.ended.connect(_enable)

func _disable():
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.bind_node(self)
	_tween.tween_property(self, "modulate:a", 0.0, FADEOUT_TIME)
	_tween.tween_callback(set_visible.bind(false))

func _enable():
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.bind_node(self)
	_tween.tween_callback(set_visible.bind(true))
	_tween.tween_property(self, "modulate:a", 1.0, FADEOUT_TIME)
