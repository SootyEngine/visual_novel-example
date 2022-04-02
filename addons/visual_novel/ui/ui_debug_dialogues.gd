extends Node

func _ready():
	DialogueStack.tick.connect(_redraw_stack)
	DialogueStack._halt_list_changed.connect(_redraw_halting)
	
	await get_tree().process_frame
	
	_redraw_dialogues()
	_redraw_stack()
	_redraw_halting()

func _redraw_dialogues():
	var text := []
	var meta := {}
	for did in Dialogues.cache:
		var d: Dialogue = Dialogues.cache[did]
		text.append("[b]%s[]" % [did])
		for fid in d.flows:
			var flow := "%s.%s" % [did, fid]
			text.append("\t[meta %s]%s[]" % [flow, fid])
			meta[flow] = DialogueStack.goto.bind(flow, DialogueStack.STEP_GOTO)
	$VBoxContainer/HBoxContainer/dialogues.set_bbcode("\n".join(text))
	$VBoxContainer/HBoxContainer/dialogues._meta = meta

func _redraw_stack():
	var text := []
	var meta := {}
	for part in DialogueStack._stack:
		text.append(str(part))
		var d: Dialogue = Dialogues.get_dialogue(part.did)
		for i in range(len(part.lines)):
			var line = d.get_line(part.lines[i])
			if i < part.step:
				text.append("\t[color=#%s]%s[/color]" % [Color.SLATE_GRAY.to_html(), str(line)])
			elif i == part.step:
				text.append("\t[color=#%s]%s[/color]" % [Color.YELLOW_GREEN.to_html(), str(line)])
			else:
				text.append("\t" + str(line))
	$VBoxContainer/HBoxContainer/stack.set_text("\n".join(text))
	$VBoxContainer/HBoxContainer/stack._meta = meta

func _redraw_halting():
	var text := []
	text.append("Waiting for...")
	for h in DialogueStack._halting_for:
		text.append(str(h.get_path()))
	$VBoxContainer/halting_for.set_text("\n".join(text))
