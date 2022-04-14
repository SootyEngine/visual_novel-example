extends Node

func _ready() -> void:
	if not Engine.is_editor_hint():
		Dialogue.started.connect(_dialogue_started)
		Dialogue.ended.connect(_dialogue_ended)
		Dialogue.caption.connect(_caption)
#		Dialogue.reloaded.connect(Dialogue.unwait.bind(self))
	
	$captions/backing.visible = false

func _dialogue_started():
	$captions/backing.visible = true

func _dialogue_ended():
	$captions/backing.visible = false

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		set_process_input(false)
		return
	
	if event.is_action_pressed("advance"):
		if VisualNovel.is_waiting():
			StringAction.do("@advance_caption")
		else:
			StringAction.do("@hide_caption")
			Dialogue.unwait(self)

func _caption(text: String, line: Dictionary):
	# replace list patterns
	text = Dialogue.replace_list_text(line.M.id, text)
	
	var d := DialogueTools.str_to_dialogue(text)
#	d.text = DialogueTools.str_to_caption(d.from, d.text)
#	d.from = DialogueTools.str_to_speaker(d.from)
	
	StringAction.call_group_w_args("@show_caption", [
#		format_from(from),
#		format_text(from , text),
		d.from,
		d.text,
		line])
