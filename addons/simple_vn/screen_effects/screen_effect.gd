extends Node

var _tween: Tween

func _create_tween() -> Tween:
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	return _tween
