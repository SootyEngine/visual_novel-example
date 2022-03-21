extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ready_deferred.call_deferred()
	var rt: RichTextLabel = $RichTextLabel
	rt.meta_clicked.connect(_meta_clicked)

func _meta_clicked(scene: String):
	print("GOTO SCENE ", scene)
	get_tree().change_scene(scene)

func _ready_deferred():
	var rt: RichTextLabel = $RichTextLabel
	rt.clear()
	for scene in SimpleVN.scenes:
		rt.push_meta(SimpleVN.scenes[scene])
		rt.append_text(scene)
		rt.pop()
		rt.newline()
