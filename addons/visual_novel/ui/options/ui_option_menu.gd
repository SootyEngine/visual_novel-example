extends Control

@export var _button_parent: NodePath = ""
@export var _button_prefab: NodePath = ""
@onready var button_parent: Node = get_node(_button_parent)
@onready var button_prefab: Node = get_node(_button_prefab)

var _can_select := false
var _tween: Tween
var _options: Array

var hovered := 0:
	set(h):
		h = clampi(h, 0, button_parent.get_child_count()-1)
		if hovered != h:
			hovered = h
			
			for i in button_parent.get_child_count():
				var n: Control = button_parent.get_child(i)
				n.hovered = i == h

func _ready() -> void:
	button_parent.remove_child(button_prefab)
	Dialogue.reloaded.connect(_hide)
	Dialogue.ended.connect(_hide)
	set_enabled(false)

func _process(delta: float) -> void:
	for i in button_parent.get_child_count():
		if button_parent.get_child(i).is_mouse_over():
			hovered = i

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		hovered -= 1
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_down"):
		hovered += 1
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("advance") and _can_select:
		var op = _options[hovered].id
		_select(op)
		get_viewport().set_input_as_handled()

func has_options() -> bool:
	return len(_options) > 0

func set_options(line: Dictionary):
	if Dialogue.line_has_options(line):
		_options = Dialogue.line_get_options(line)
		if not VisualNovel.debug.show_hidden_options:
			_options = _options.filter(func(x): return x.passed)
	else:
		_options = []
	
	set_enabled(true)
	modulate.a = 0.0
	_can_select = false
	_create_options()

func set_enabled(e):
	visible = e
	set_process(e)
	set_process_input(e)

func _show_options():
	modulate.a = 1.0
	get_tree().create_timer(0.5).timeout.connect(set.bind("_can_select", true))

func _create_options():
	size.y = 0.0
	
	for i in len(_options):
		var option: Dictionary = _options[i]
		var button := button_prefab.duplicate()
		button_parent.add_child(button)
		button.set_owner(owner)
		button.set_option(option)
		button.pressed.connect(_select.bind(option.id))
		button.hovered = i == 0
	
	hovered = 0
	hide()
	show()

func _select(option: String):
	if not _can_select:
		return
	
	_hide()
	_can_select = false
	
	Dialogue.select_option(option)

func _hide():
	set_enabled(false)
	
	for button in button_parent.get_children():
		button_parent.remove_child(button)
		button.queue_free()

func _create_tween() -> Tween:
	if _tween:
		_tween.stop()
	_tween = get_tree().create_tween()
	return _tween
