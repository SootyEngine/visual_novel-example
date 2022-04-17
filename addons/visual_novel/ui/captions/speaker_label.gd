@tool
extends RichTextLabel2

@export var disabled := false
@export var active := false

@export var head := "[dima;lb;]":
	set(x):
		head = x
		_redraw()
		
@export var tail := "[dima;rb;]":
	set(x):
		tail = x
		_redraw()

func _init():
	add_to_group("@.speaker_label")
	
func _ready() -> void:
	if not Engine.is_editor_hint():
		VisualNovel.caption_started.connect(_caption_started)
		VisualNovel.caption_ended.connect(_caption_ended)
		VisualNovel.option_selected.connect(_option_selected)
		clear()

func _preparse(t: String) -> String:
	return super._preparse(head + t + tail)

func _caption_started():
	if disabled:
		return
	
	if VisualNovel.speaker:
		active = true
		set_bbcode(VisualNovel.speaker)

func _caption_ended():
	clear()
	active = false

func _option_selected():
	pass

func speaker_label(id: String, kwargs := {}):
	disabled = id != name
