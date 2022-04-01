extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ready_deferred.call_deferred()
	var rt: RichTextLabel = $RichTextLabel
	rt.meta_clicked.connect(_meta_clicked)

func _meta_clicked(scene: String):
	print("Goto scene ", scene)
	Scene.change(scene)

func _ready_deferred():
	var text := []
	var meta := {}
	for scene in Scene.scenes:
		text.append("[meta %s]%s[]" % [scene, scene])
		meta[scene] = Scene.change.bind(scene)
#		rt.push_meta(scene)#Scenes.scenes[scene])
#		rt.append_text(scene)
#		rt.pop()
#		rt.newline()
	var rt: RichTextLabel = $RichTextLabel
	rt.set_bbcode("\n".join(text))
	rt._meta = meta
