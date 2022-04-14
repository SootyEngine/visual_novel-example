@tool
extends RichTextLabel2

@export var disabled := false

func _ready() -> void:
	add_to_group("@.speaker_label")
	Dialogue.caption.connect(_caption)

func _caption(speaker: String, caption: String, kwargs := {}):
	if disabled:
		return

func speaker_label(id: String, kwargs := {}):
	disabled = id != name
