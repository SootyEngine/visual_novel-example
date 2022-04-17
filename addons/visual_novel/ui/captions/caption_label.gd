@tool
extends RichTextAnimation

@export var disabled := false

func _init() -> void:
	add_to_group("@.caption_label")
	add_to_group("@.advance_caption")

func _ready() -> void:
	visible = false
	if not Engine.is_editor_hint():
		VisualNovel.caption_started.connect(_caption_started)
		VisualNovel.caption_ended.connect(_caption_ended)
		VisualNovel.option_selected.connect(_option_selected)
		clear()

func _caption_started():
	if disabled:
		return
	
	visible = true
	VisualNovel.wait(self)
	set_bbcode(VisualNovel.caption)
	
	# skip text animation?
	if Settings.instant_text_animation:
		advance()

func _caption_ended():
	#TODO: check if same as current, then we don't need to go away
	visible = false
	clear()

func advance_caption():
	if can_advance():
		advance()
	else:
		VisualNovel.unwait(self)
		visible = false

func _option_selected():
	VisualNovel.unwait(self)

func caption_label(id: String, kwargs := {}):
	disabled = id != name
