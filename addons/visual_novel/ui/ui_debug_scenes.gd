extends Node

func _ready() -> void:
	await get_tree().process_frame
	
	var text := []
	var meta := {}
	var scenes = Scene.scenes.keys()
	scenes.sort()
	
	for scene in scenes:
		text.append("[meta %s]%s[]" % [scene, scene])
		meta[scene] = _goto_scene.bind(scene)
	var rt: RichTextLabel = $RichTextLabel
	rt.set_bbcode("\n".join(text))
	rt._meta = meta

func _goto_scene(scene: String):
	DialogueStack.end()
	Scene.change(scene)
