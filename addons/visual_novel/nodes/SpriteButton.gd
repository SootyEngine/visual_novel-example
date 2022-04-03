@tool
extends SootButton

signal mouse_entered
signal mouse_exited
signal button_down
signal button_up
signal pressed

@export var disabled := false:
	set(v):
		disabled = v
		if disabled:
			_hovered = false

@export var default_cursor_shape:Input.CursorShape = Input.CURSOR_POINTING_HAND

var _hovered := false:
	set(v):
		if _hovered != v:
			_hovered = v
			if _hovered:
				Input.set_default_cursor_shape(default_cursor_shape)
				mouse_entered.emit()
			else:
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)
				mouse_exited.emit()

var _pressed := false:
	set(v):
		if _pressed != v:
			_pressed = v
			if _pressed:
				button_down.emit()
				pressed.emit()
			else:
				button_up.emit()

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	if not disabled:
		# detect mouse over
		if event is InputEventMouseMotion:
			_hovered = _is_pixel_opaque()
		
		# detect pressed
		elif event is InputEventMouseButton:
			if _hovered:
				_pressed = event.pressed
				get_viewport().set_input_as_handled()

func _is_pixel_opaque() -> bool:
	if get_class() == "Sprite2D":
		if self.is_pixel_opaque(self.get_local_mouse_position()):
			return true
	
	for child in get_children():
		if child is Sprite2D:
			if child.is_pixel_opaque(child.get_local_mouse_position()):
				return true
	
	return false
