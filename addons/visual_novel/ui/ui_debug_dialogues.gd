extends Node

func _ready():
	await ModManager.loaded
	
	Dialogue.step_started.connect(_redraw_stack)
	VisualNovel.waiting_changed.connect(_redraw_halting)
	$VBoxContainer/reload.pressed.connect(_reload)
	
	_redraw_dialogues()
	_redraw_stack()
	_redraw_halting()

func _reload():
	ModManager._load_mods()

func _redraw_dialogues():
	var text := []
	var meta := {}
	for d_id in Dialogue._flows:
		var d: Dictionary = Dialogue._flows[d_id]
		text.append("[b]%s[]" % [d_id])
		for f_id in d.flows:
			text.append("\t[meta %s]%s[]" % [f_id, f_id])
			meta[f_id] = Dialogue.goto.bind(f_id)
	$VBoxContainer/HBoxContainer/dialogues.set_bbcode("\n".join(text))
	$VBoxContainer/HBoxContainer/dialogues._meta = meta

func _redraw_stack():
	var text := []
	var meta := {}
	for part in Dialogue._stack:
		text.append(str(part))
#		var d: Dictionary = Dialogue.get_dialogue(part.d_id)
#		for i in range(len(part.lines)):
#			var line# = d.get_line(part.lines[i])
#			if i < part.step:
#				text.append("\t[color=#%s]%s[/color]" % [Color.SLATE_GRAY.to_html(), str(line)])
#			elif i == part.step:
#				text.append("\t[color=#%s]%s[/color]" % [Color.YELLOW_GREEN.to_html(), str(line)])
#			else:
#				text.append("\t" + str(line))
	$VBoxContainer/HBoxContainer/stack.set_text("\n".join(text))
	$VBoxContainer/HBoxContainer/stack._meta = meta

func _redraw_halting():
	var text := []
	text.append("Waiting for...")
	for h in VisualNovel.waiting_for:
		text.append(str(h.get_path()))
	$VBoxContainer/halting_for.set_text("\n".join(text))
