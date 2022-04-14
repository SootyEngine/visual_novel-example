@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("VisualNovel", "res://addons/visual_novel/autoloads/VisualNovel.gd")
	add_autoload_singleton("VisualNovelUI", "res://addons/visual_novel/autoloads/VisualNovelUI.tscn")

func _exit_tree() -> void:
	remove_autoload_singleton("VisualNovel")
	remove_autoload_singleton("VisualNovelUI")
