@tool
extends RichTextAnimation

@export var disabled := false

func _ready() -> void:
	add_to_group("@.caption_label")
	Dialogue.caption.connect(_caption)

func _caption(speaker: String, caption: String, kwargs := {}):
	if disabled:
		return

func caption_label(id: String, kwargs := {}):
	disabled = id != name
