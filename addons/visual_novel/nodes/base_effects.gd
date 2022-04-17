extends Node2D

var _tween: Tween
var _tween_frame: int

func _create(kwargs := {}) -> Tween:
	var t_frame := get_tree().get_frame()
	if t_frame == _tween_frame:
		return _tween
	
	if _tween and _tween_frame:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.bind_node(self)
	_tween.set_parallel(true)
	_tween_frame = t_frame
	
	if "loop" in kwargs:
		_tween.set_loops(kwargs.loop)
	
	return _tween
