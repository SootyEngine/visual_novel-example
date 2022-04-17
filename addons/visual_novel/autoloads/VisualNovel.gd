@tool
extends Node

const VERSION := "1.0"

# for autocomplete
func _get_group_action_info():
	return {
		"@:VisualNovel": {
			"text": "Visual Novel v%s" % VERSION,
			"tint": Color.ORANGE_RED,
			"icon": preload("res://addons/visual_novel/icons/visual_novel.png")
		}
	}

signal waiting_changed()
signal caption_started()
signal caption_ended()
signal option_selected()

class Debug:
	# when displaying dialogue options, do you want hidden ones to be shown?
	var show_hidden_options := false
	# toggle with q
	var allow_debug_menu := true

var debug := Debug.new()
var grammar := Grammar.new()
var last_speaker: String
var waiting_for := []

var caption := ""
var speaker := ""
var option := ""
var current_line: Dictionary
var scene: Scene

func version() -> String:
	return VERSION

func _init() -> void:
	add_to_group("@:VisualNovel")
	add_to_group("has_editor_buttons")

func _get_editor_buttons():
	if scene:
		return [
			{
				text="Edit %s.soot" % scene.scene_id,
				call=func(): print("Wow it worked.")
			}]

func _ready() -> void:
	await get_tree().process_frame
	ModManager._add_mod("res://addons/visual_novel", true)
	SceneManager._goto = _goto_scene
	SceneManager.changed.connect(_scene_changed)
	Dialogue.caption.connect(_caption)
	Dialogue.selected.connect(_selected)
	Dialogue.ended.connect(_dialogue_ended)
	State._changed.connect(_state_changed)
	Persistent._changed.connect(_state_changed)

func _get_scene_flow_path(path: String):
	return "/%s/%s" % [scene.scene_id, path]

func _state_changed(property: String):
	if scene:
		var flow_path: String = "/%s/_changed/%s" % [scene.scene_id, property]
		if Dialogue.has_path(flow_path):
			Dialogue.goto_and_return(flow_path)

func _scene_changed():
	if not get_tree().current_scene is Scene:
		scene = null
		return
	
	scene = get_tree().current_scene
	
	# execute the scene_init
	var fi := _get_scene_flow_path("_init")
	if Dialogue.has_path(fi):
		Dialogue.execute(fi)
	
	var fs := _get_scene_flow_path("_started")
	# if dialogue is already running, add this to the end of the current flow
	if Dialogue.is_active():
		Dialogue.ended.connect(Dialogue.start.bind(fs), CONNECT_ONESHOT)
	# otherwise, start a dialogue
	else:
		Dialogue.start(fs)

# an option was selected
# tell ui nodes to react
func _selected(id: String):
	option = id
	option_selected.emit()

func is_scene() -> bool:
	return scene != null

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		set_process_input(false)
		return
	
	if event.is_action_pressed("advance"):
		if is_waiting():
			StringAction.do("@advance_caption")
		else:
			StringAction.do("@hide_caption")
			unwait(self)
	
	# run input for captions
	for node in waiting_for:
		if node.has_method("_vn_input"):
			node._vn_input(event)

func _caption(text: String, line := {}):
	# replace list patterns
	text = Dialogue.replace_list_text(line.M.id, text)
	
	var info := DialogueTools.str_to_dialogue(text)
	if info.from == DialogueTools.LAST_SPEAKER:
		info.from = last_speaker
	elif info.from:
		last_speaker = info.from
	
	var had_caption := true if line else false
	
	current_line = line
	speaker = DialogueTools.str_to_speaker(info.from)
	caption = DialogueTools.str_to_caption(info.from, info.text)
	
	# signal the next speaker, since nodes might not want to hide if it's the same speaker
	if had_caption:
		caption_ended.emit()
	caption_started.emit()

func _goto_scene(id: String, kwargs := {}):
	if Scene.find(id):
		wait(self)
		Fader.create(
			SceneManager.change.bind(SceneManager.scenes[id]),
			unwait.bind(self))
	else:
		# Scene.find will push_error with more useful data.
		pass

func _dialogue_ended():
	current_line = {}
	speaker = ""
	caption = ""
	caption_ended.emit()

# causes the dialogue to pause
func wait(node: Node):
	if not node in waiting_for:
		Dialogue.break_step()
		waiting_for.append(node)
		waiting_changed.emit()

# unpauses dialogue, when empty
func unwait(node: Node):
	if node in waiting_for:
		waiting_for.erase(node)
		waiting_changed.emit()

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if not is_waiting() and Dialogue.is_active():
			Dialogue.step()

func is_waiting() -> bool:
	return len(waiting_for) > 0

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
