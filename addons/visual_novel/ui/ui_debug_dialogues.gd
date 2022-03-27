extends Node

func _init() -> void:
	DialogueStack.tick_started.connect(_redraw_stack)

func _ready():
	_ready_deferred.call_deferred()

func _ready_deferred():
	var text := []
	var meta := {}
	for did in Dialogues.cache:
		var d: Dialogue = Dialogues.cache[did]
		text.append("[b]%s[]" % [did])
		for fid in d.flows:
			var flow := "%s.%s" % [did, fid]
			text.append("\t[meta %s]%s[]" % [flow, fid])
			meta[flow] = DialogueStack.goto.bind(flow, DialogueStack.STEP_GOTO)
	$HBoxContainer/RichTextLabel.set_bbcode("\n".join(text))
	$HBoxContainer/RichTextLabel._meta = meta
	
	_redraw_stack()

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
	$HBoxContainer/RichTextLabel2.set_text("\n".join(text))
	$HBoxContainer/RichTextLabel2._meta = meta
