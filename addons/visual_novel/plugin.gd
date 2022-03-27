@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("VisualNovel", "res://addons/visual_novel/autoloads/VisualNovel.tscn")

func _exit_tree() -> void:
	remove_autoload_singleton("VisualNovel")
