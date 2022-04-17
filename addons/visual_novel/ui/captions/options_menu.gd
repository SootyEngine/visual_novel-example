extends Control

@export var _button_parent: NodePath = "."
@export var _button_prefab: NodePath = "option"
@onready var button_parent: Node = get_node(_button_parent)
@onready var button_prefab: Node = get_node(_button_prefab)

var _can_select := false
var _tween: Tween
var _options: Array

var hovered := 0:
	set = set_hovered

func _ready() -> void:
	button_parent.remove_child(button_prefab)
	
	Dialogue.reloaded.connect(_hide)
	Dialogue.ended.connect(_hide)
	VisualNovel.caption_started.connect(_caption_started)
	VisualNovel.caption_ended.connect(_caption_ended)
	VisualNovel.option_selected.connect(_caption_ended)
	set_enabled(false)
	visible = false

func _caption_started():
	var line: Dictionary = VisualNovel.current_line
	
	if Dialogue.line_has_options(line):
		_options = Dialogue.line_get_options(line)
		if not VisualNovel.debug.show_hidden_options:
			_options = _options.filter(func(x): return x.passed)
		
		set_enabled(true)
		_can_select = false
		_create_buttons()
		
		modulate.a = 1.0
		VisualNovel.wait(self)
		get_tree().create_timer(0.5).timeout.connect(set.bind("_can_select", true))

func _caption_ended():
	if _options:
		_options = []
		VisualNovel.unwait(self)
		set_enabled(false)

func _vn_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		for i in button_parent.get_child_count():
			if button_parent.get_child(i).is_mouse_over():
				hovered = i
		
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

func set_hovered(h: int):
	h = clampi(h, 0, button_parent.get_child_count()-1)
	if hovered != h:
		hovered = h
		
		for i in button_parent.get_child_count():
			var n: Control = button_parent.get_child(i)
			n.hovered = i == h

func set_enabled(e):
	visible = e

func _create_buttons():
	size.y = 0.0
	
	for i in len(_options):
		var option: Dictionary = _options[i]
		var button := button_prefab.duplicate()
		button_parent.add_child(button)
		button.visible = true
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
	
	get_tree().process_frame
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
