@tool
extends RichTextLabel2

@export var disabled := false
@export var active := false

@export var head := "[dim;lb]":
	set(x):
		head = x
		_redraw()
		
@export var tail := "[dim;rb]":
	set(x):
		tail = x
		_redraw()

func _ready() -> void:
	add_to_group("@.speaker_label")
	VisualNovel.caption_started.connect(_caption_started)
	VisualNovel.caption_ended.connect(_caption_ended)
	clear()

func _preparse(t: String) -> String:
	return super._preparse(head + t + tail)

func _caption_started(speaker: String, caption: String, kwargs := {}):
	if disabled:
		return
	
	if speaker:
		active = true
		set_bbcode(speaker)

func _caption_ended():
	clear()
	active = false

func speaker_label(id: String, kwargs := {}):
	disabled = id != name
