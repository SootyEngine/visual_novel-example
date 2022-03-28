extends Node

const VERSION := "1.0"
const FORMAT_FROM := "[white]｢[]%s[white]｣[]"
const FORMAT_ACTION := "[gray;i]*%s*[]"
const FORMAT_PREDICATE := "[dim]%s[]"
const FORMAT_QUOTE := "[q]%s[]"
const FORMAT_INNER_QUOTE := "[i]%s[]"
const QUOTE_DELAY := 0.5 # a delay between predicates and quotes.
const QUOTES := "“%s”" # nice quotes
const INNER_QUOTES := "‘%s’" # nice inner quotes

var last_speaker := ""

class Debug:
	# when displaying dialogue options, do you want hidden ones to be shown?
	var show_hidden_options := false
	
	# toggle with q
	var allow_debug_menu := false

var debug := Debug.new()

func _init():
	add_to_group("sa:visual_novel_version")

func _ready() -> void:
	Mods._add_mod("res://addons/visual_novel", true)
	
	DialogueStack.started.connect(_dialogue_started)
	DialogueStack.ended.connect(_dialogue_ended)
	DialogueStack.flow_started.connect(_flow_started)
	DialogueStack.flow_ended.connect(_flow_ended)
	DialogueStack.on_line.connect(_on_text)
	
	$captions/backing.visible = false

func visual_novel_version() -> String:
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
	if len(State.flow_history) and State.flow_history[-1] != "MAIN.FLOW_END":
		DialogueStack.goto("MAIN.FLOW_END", DialogueStack.STEP_GOTO)

func _input(event: InputEvent) -> void:
	if not DialogueStack.is_active():
		return
	
	if event.is_action_pressed("advance"):
		var waiting_for := []
		_caption_msg("advance", waiting_for)
		if len(waiting_for):
			print("Waiting for ", waiting_for)
		else:
			_caption_msg("hide")
			DialogueStack.unhalt(self)

func _caption_msg(msg_type: String, msg: Variant = null):
	Global.call_group_flags(SceneTree.GROUP_CALL_REALTIME, "caption", "_caption", [State.caption_at, msg_type, msg])

func _on_text(line: DialogueLine):
	var from = line.from
	if from == null:
		pass
	elif from == "":
		from = last_speaker
	elif last_speaker != "":
		last_speaker = from
	
	if from is String:
		if UString.is_wrapped(from, '"'):
			from = UString.unwrap(from, '"')
		
		elif " " in from:
			var names = Array(from.split(" "))
			for i in len(names):
				if State._has(names[i]):
					names[i] = UString.as_string(State._get(names[i]))
			from = names.pop_back()
			if len(names):
				from = ", ".join(names) + ", and " + from
			
		elif State._has(from):
			from = UString.as_string(State._get(from))
		
		from = FORMAT_FROM % from
	
	DialogueStack.halt(self)
	_caption_msg("show_line", {
		from=from,
		text=_format_text(line.text, from != null),
		line=line
	})

func _format_text(text: String, has_from: bool) -> String:
	var out := ""
	var part_count := 0
	# when someone is speaking, use brakets to toggle 'predicate' mode.
	if has_from:
		var parts = UString.split_between(text, "(", ")")
		for p in parts:
			if not part_count == 0:
				out += "[w=%s]" % QUOTE_DELAY
			var whitespace = _get_whitespace_format(p)
			if UString.is_wrapped(p, '(', ')'):
				p = UString.unwrap(p, '(', ')').strip_edges()
				out += whitespace % FORMAT_PREDICATE % p
			else:
				p = p.strip_edges()
				p = UString.replace_between(p, '"', '"', _replace_inner_quotes)
				out += whitespace % FORMAT_QUOTE % QUOTES % p
			part_count += 1
	else:
		var parts = UString.split_between(text, "\"", "\"")
		for p in parts:
			if not part_count == 0:
				out += "[w=%s]" % QUOTE_DELAY
			var whitespace = _get_whitespace_format(p)
			if UString.is_wrapped(p, '"'):
				p = UString.unwrap(p, '"')
				p = UString.replace_between(p, "'", "'", _replace_inner_quotes)
				out += whitespace % FORMAT_QUOTE % QUOTES % p
			else:
				p = p.strip_edges()
				out += whitespace % FORMAT_PREDICATE % p
			part_count += 1
	return out

func _replace_inner_quotes(t: String) -> String:
	return FORMAT_INNER_QUOTE % INNER_QUOTES % t

# get the left and right whitespace, as a format string.
func _get_whitespace_format(s: String):
	var l := len(s) - len(s.strip_edges(true, false))
	var r := len(s) - len(s.strip_edges(false, true))
	return s.substr(0, l) + "%s" + s.substr(len(s) - r)

