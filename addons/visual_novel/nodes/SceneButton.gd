extends Button

@export var id := name
@export var local_to_scene := false

func _pressed() -> void:
	var flow: String
	if local_to_scene:
		flow = VisualNovel._get_scene_flow_path("_pressed/%s" % id)
	else:
		flow = "/%s/_pressed" % id
	Dialogue.goto(flow)
