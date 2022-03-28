extends Control

func _ready() -> void:
	await get_tree().process_frame
	
	for btn in $buttons.get_children():
		if not _is_visible(str(btn.name)):
			btn.visible = false
		else:
			btn.pressed.connect(_pressed.bind(str(btn.name)))

func _is_visible(id: String) -> bool:
	match id:
		"continue": return Saver.has_last_save()
		_: return true

func _pressed(id: String):
	match id:
		"continue": Saver.load_last_save()
		"start": Global.start()
		"load": Scenes.goto("load_game_menu")
		"quit": Global.quit()
	
	grab_focus()
	release_focus()
