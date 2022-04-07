extends Node

var text := ""
var lines := []
var filter := ""
var persistent := false
var only_modified := false
var hide_empty := false
var show_type := false

func _ready() -> void:
	$VBoxContainer/CodeEdit.syntax_highlighter = preload("res://addons/sooty_engine/data/DataHighlighterRuntime.gd").new()
	$VBoxContainer/HBoxContainer/persistent.toggled.connect(_toggle_persistent)
	$VBoxContainer/HBoxContainer/force_update.pressed.connect(_update)
	$VBoxContainer/HBoxContainer/force_reload.pressed.connect(_force_reload)
	$VBoxContainer/HBoxContainer/only_modified.toggled.connect(_toggle_only_modified)
	$VBoxContainer/HBoxContainer/show_type.toggled.connect(_toggle_show_type)
	$VBoxContainer/HBoxContainer/hide_empty.toggled.connect(_hide_empty)
	$VBoxContainer/HBoxContainer/filter.text_changed.connect(_filter_changed)
	State.changed.connect(_changed)
	Persistent.changed.connect(_changed)
	Mods.loaded.connect(_changed)

func _force_reload():
	Mods._load_mods()

func _toggle_persistent(t):
	persistent = t
	_update()

func _toggle_show_type(t):
	show_type = t
	_update()

func _toggle_only_modified(t):
	only_modified = t
	_update()

func _hide_empty(t):
	hide_empty = t
	_update()

func _changed(_property=null):
	_update()

func _filter_changed(t: String):
	filter = t
	_redraw()

func _update():
	var node = Persistent if persistent else State
	var state := node._get_changed_states() if only_modified else node._get_state()
	if hide_empty:
		state = UDict.trim_empty(state)
	text = DataParser.dict_to_str(state, show_type)
	lines = Array(text.split("\n")).map(func(x): return x.to_lower())
	var c: CodeEdit = $VBoxContainer/CodeEdit
	var l: int = c.get_first_visible_line()
	c.set_text(text)
	c.set_line_as_first_visible(l)
	_redraw()

func _redraw():
	var c: CodeEdit = $VBoxContainer/CodeEdit
	for i in len(lines):
		if filter == "" or filter in lines[i]:
			c.unfold_line(i)
		else:
			c.fold_line(i)
	
	if filter != "":
		for i in c.get_line_count():
			var a = lines[i].find(filter)
			if a != -1:
#				c.set_caret_line(i, false)
#				c.set_caret_column(a)
				c.select(i, a, i, a+len(filter))
				break
	
