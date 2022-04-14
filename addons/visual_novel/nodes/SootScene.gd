@tool
extends Node
class_name SootScene

@export var flow: String = "":
	set(v): flow = v if v else UFile.get_file_name(scene_file_path)

func _ready() -> void:
	if not Engine.is_editor_hint():
		State.changed.connect(_property_changed)

func _path(path: String) -> String:
	return "/%s/%s" % [flow, path]

func _start(loaded: bool):
	var fi := _path("scene_init")
	if Dialogue.has_path(fi):
		Dialogue.execute(fi)
	
	if not loaded:
		var fs := _path("scene_started")
		if Dialogue.is_active():
			Dialogue.ended.connect(Dialogue.goto.bind(fs), CONNECT_ONESHOT)
		else:
			Dialogue.goto(fs)

func _property_changed(property: String):
	var fs := _path("CHANGED_%s" % property)
	if Dialogue.has_path(fs):
		Dialogue.execute(fs)

func _get_tool_buttons():
	# edit existing
	if flow in Dialogue._flows:
		var meta_data: Dictionary = Dialogue._flows[flow].M
		var file_path: String = meta_data.file
		var file_line: int = meta_data.line
		return [{
			text="Edit %s" % file_path.get_file(),
			call="@SELECT_AND_EDIT;%s" % file_path,
			hint="Edit %s." % file_path
		}]
	else:
		# file exists
		var new_path := "res://dialogue/%s.%s" % [flow, Soot.EXT_DIALOGUE]
		if UFile.exists(new_path):
			return [{
				text="Edit %s" % new_path.get_file(),
				call="@SELECT_AND_EDIT;%s" % new_path,
				hint="Edit %s." % new_path
			}]
		
		# create new
		else:
			
			var new_data := "=== %s\n\t=== started\n\t\tHello world.\n\t\tStarted scene %s." % [flow, flow.capitalize()]
			return [{
				text="Create %s" % [new_path.get_file()],
				call="@CREATE_AND_EDIT;%s;%s" % [new_path, new_data],
				hint="Create %s." % new_path}]
