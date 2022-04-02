extends Control

@export var _button_parent: NodePath = ""
@export var _button_prefab: NodePath = ""
@export var _selection_indicator: NodePath = ""
@onready var button_parent: Node = get_node(_button_parent)
@onready var button_prefab: Node = get_node(_button_prefab)
@onready var selection_indicator: Node = get_node(_selection_indicator)

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
		
		_fix_indicator_position.call_deferred()

func _ready() -> void:
	button_parent.remove_child(button_prefab)
	DialogueStack._refresh.connect(_hide)
	DialogueStack.ended.connect(_hide)

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("ui_up"):
			hovered -= 1
			get_viewport().set_input_as_handled()
		
		elif event.is_action_pressed("ui_down"):
			hovered += 1
			get_viewport().set_input_as_handled()
		
		elif event.is_action_pressed("advance") and _can_select:
			_select(_options[hovered])
			get_viewport().set_input_as_handled()

func has_options() -> bool:
	return len(_options) > 0

func _set_line(line: DialogueLine):
	if line.has_options():
		_options = line.get_options()
		if not VisualNovel.debug.show_hidden_options:
			_options = _options.filter(func(x): return x.passed)
	else:
		_options = []
	
	visible = true
	modulate.a = 0.0
	_can_select = false
	_create_options()

func _show_options():
	modulate.a = 1.0
	get_tree().create_timer(0.5).timeout.connect(set.bind("_can_select", true))

func _create_options():
	size.y = 0.0
	
	for i in len(_options):
		var option = _options[i]
		var button := button_prefab.duplicate()
		button_parent.add_child(button)
		button.set_owner(owner)
		button.set_option(option)
		button.pressed.connect(_select.bind(option))
		button.hovered = i == 0
	
	hovered = 0
	hide()
	show()

func _select(option: DialogueLine):
	if not _can_select:
		return
	
	_hide()
	_can_select = false
	
	DialogueStack.select_option(option)

func _hide():
	visible = false
	
	for button in button_parent.get_children():
		button_parent.remove_child(button)
		button.queue_free()

func _create_tween() -> Tween:
	if _tween:
		_tween.stop()
	_tween = get_tree().create_tween()
	return _tween

func _fix_indicator_position():
		var n: Control = button_parent.get_child(hovered)
		if n:
			selection_indicator.position.x = n.position.x + 14
			selection_indicator.position.y = n.position.y + 16
