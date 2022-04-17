extends Control

func _ready() -> void:
	visible = false
	VisualNovel.caption_started.connect(_caption_started)
	VisualNovel.caption_ended.connect(_caption_ended)

func _caption_started():
	visible = true

func _caption_ended():
	visible = false
