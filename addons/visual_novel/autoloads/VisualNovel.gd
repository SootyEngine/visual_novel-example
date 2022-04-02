extends Node

const VERSION := "1.0"
const FORMAT_FROM := "[white;dim]｢[] %s [white;dim]｣[]"
const FORMAT_ACTION := "[gray;i]*%s*[]"
const FORMAT_PREDICATE := "[dim]%s[]"
const FORMAT_QUOTE := "[q]%s[]"
const FORMAT_INNER_QUOTE := "[i]%s[]"
const QUOTE_DELAY := 0.25 # a delay between predicates and quotes.

class Debug:
	# when displaying dialogue options, do you want hidden ones to be shown?
	var show_hidden_options := false
	
	# toggle with q
	var allow_debug_menu := true

var debug := Debug.new()

func _ready() -> void:
	Mods._add_mod("res://addons/visual_novel", true)
	
	DialogueStack.started.connect(_dialogue_started)
	DialogueStack.ended.connect(_dialogue_ended)
	DialogueStack.flow_started.connect(_flow_started)
	DialogueStack.flow_ended.connect(_flow_ended)
	DialogueStack.on_line.connect(_on_text)
	DialogueStack._refresh.connect(DialogueStack.unhalt.bind(self))
	
	$captions/backing.visible = false

func version() -> String:
	return "[%s]%s[]" % [Color.TOMATO, VERSION]

func _dialogue_started():
	$captions/backing.visible = true
	State.flow_history.clear()

func _dialogue_ended():
	$captions/backing.visible = false

func _flow_started(flow: String):
	State.flow_history.append(flow)

func _flow_ended(flow: String):
	UDict.tick(State.flow_visited, flow) # tick number of times visited
	
	# goto the ending node
	if len(State.flow_history) and State.flow_history[-1] != Soot.M_FLOW_END and Dialogues.has_dialogue_flow(Soot.M_FLOW_END):
		DialogueStack.goto(Soot.M_FLOW_END)

func _caption_msg(msg_type: String, msg: Variant = null):
	Global.call_group_flags(SceneTree.GROUP_CALL_REALTIME, "caption", "_caption", [State.caption_at, msg_type, msg])

func _on_text(line: DialogueLine):
	var from = format_from(line.from)
	var text := format_text(line.text, from != null)
	_caption_msg("show_line", {
		from=from,
		text=text,
		line=line
	})

func format_from(from: Variant) -> Variant:
	if from is String:
		# if wrapped, use as is.
		if UString.is_wrapped(from, '"'):
			from = UString.unwrap(from, '"')
		
		# if multiple names, join them together.
		elif " " in from:
			var names = Array(from.split(" "))
			for i in len(names):
				if State._has(names[i]):
					names[i] = UString.as_string(State._get(names[i]))
			from = names.pop_back()
			if len(names):
				from = ", ".join(names) + ", and " + from
		
		# if a state, format it's text.
		elif State._has(from):
			from = UString.as_string(State._get(from))
		
		from = FORMAT_FROM % from
	
	return from

func format_text(text: String, has_speaker: bool) -> String:
	if has_speaker:
		return _format_text(text,
		"(", ")",
		"[i;dim]", "[]",
		UString.CHAR_QUOTE_OPENED, UString.CHAR_QUOTE_CLOSED)
	else:
		return _format_text(UString.fix_quotes(text),
		UString.CHAR_QUOTE_OPENED, UString.CHAR_QUOTE_CLOSED,
		UString.CHAR_QUOTE_OPENED, UString.CHAR_QUOTE_CLOSED,
		'[dim]', '[]')

func _format_text(text: String,
	inner_opened := "(",
	inner_closed := ")",
	quote_opened := "{",
	quote_closed := "}",
	pred_opened := "<",
	pred_closed := ">"
	) -> String:
	var out := ""
	var leading := ""
	
	var in_pred := not text.begins_with(inner_opened)
	var start := true
	var started := false
	var in_tag := false
	
	for c in text:
		if c == "[":
			in_tag = true
			leading += c
		elif c == "]":
			in_tag = false
			leading += c
		elif in_tag:
			leading += c
		
		elif c == inner_opened:
			in_pred = false
			start = true
			if started:
				out += pred_closed
			leading += quote_opened
		
		elif c == inner_closed:
			in_pred = true
			start = true
			out += quote_closed
		
		elif c == " ":
			leading += " "
		
		else:
			if in_pred:
				if leading:
					out += leading
					leading = ""
				
				if start:
					start = false
					started = true
					out += pred_opened
			
			else:
				if leading:
					out += leading
					leading = ""
			
			out += c
	
	if in_pred and not start:
		out += pred_closed
	
	return out

#func format_text(text: String, has_speaker: bool) -> String:
#	var out := ""
#	var part_count := 0
#	# when someone is speaking, use brakets to toggle 'predicate' mode.
#	if has_speaker:
#		var parts = UString.split_between(text, "(", ")")
#		for p in parts:
#			if not part_count == 0:
#				out += "[w=%s]" % QUOTE_DELAY
#			var whitespace = _get_whitespace_format(p)
#			if UString.is_wrapped(p, '(', ')'):
#				p = UString.unwrap(p, '(', ')').strip_edges()
#				out += whitespace % FORMAT_PREDICATE % p
#			else:
#				p = p.strip_edges()
#				p = UString.replace_between(p, '"', '"', _replace_inner_quotes)
#				out += whitespace % FORMAT_QUOTE % QUOTES % p
#			part_count += 1
#	else:
#		var parts = UString.split_between(text, "\"", "\"")
#		for p in parts:
#			if not part_count == 0:
#				out += "[w=%s]" % QUOTE_DELAY
#			var whitespace = _get_whitespace_format(p)
#			if UString.is_wrapped(p, '"'):
#				p = UString.unwrap(p, '"')
#				p = UString.replace_between(p, "'", "'", _replace_inner_quotes)
#				out += whitespace % FORMAT_QUOTE % QUOTES % p
#			else:
#				p = p.strip_edges()
#				out += whitespace % FORMAT_PREDICATE % p
#			part_count += 1
#	return out

#func _replace_inner_quotes(t: String) -> String:
#	return FORMAT_INNER_QUOTE % INNER_QUOTES % t

# get the left and right whitespace, as a format string.
#func _get_whitespace_format(s: String):
#	var l := len(s) - len(s.strip_edges(true, false))
#	var r := len(s) - len(s.strip_edges(false, true))
#	return s.substr(0, l) + "%s" + s.substr(len(s) - r)

