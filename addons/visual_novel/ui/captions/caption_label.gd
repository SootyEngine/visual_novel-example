@tool
extends RichTextAnimation

@export var disabled := false
@export var active := false

func _ready() -> void:
	add_to_group("@.caption_label")
	VisualNovel.caption_started.connect(_caption_started)
	VisualNovel.caption_ended.connect(_caption_ended)
	clear()

func _caption_started(speaker: String, caption: String, kwargs := {}):
	if disabled:
		return
	
	active = true
	VisualNovel.wait(self)
	set_bbcode(caption)

func _caption_ended():
	active = false
	clear()

func _input(event: InputEvent) -> void:
	if not active:
		return
	
	if event.is_action_pressed("advance"):
		if can_advance():
			advance()
		else:
			VisualNovel.unwait(self)
			active = false

func caption_label(id: String, kwargs := {}):
	disabled = id != name
