extends Node

func _ready() -> void:
	await get_tree().process_frame
	ModManager.loaded.connect(_redraw)

func _redraw():
	var text := []
	var meta := {}
	
	text.append("[b]MUSIC[]")
	text.append("[meta stop_music]Stop[]")
	meta["stop_music"] = MusicManager.stop()
	
	for id in MusicManager._files:
		text.append("[meta music:%s]\t%s[]" % [id, id])
		meta["music:"+id] = MusicManager.play.bind(id)
		
	text.append("[b]SFX[]")
	for id in SFXManager._files:
		text.append("[meta sfx:%s]\t%s[]" % [id, id])
		meta["sfx:"+id] = SFXManager.play.bind(id)
	
	$RichTextLabel.set_bbcode("\n".join(text))
	$RichTextLabel._meta = meta
