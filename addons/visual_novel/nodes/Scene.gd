@tool
extends Node
class_name Scene

@export var scene_id: String = UFile.get_file_name(scene_file_path)

func _init() -> void:
	add_to_group("@:scene")

#func _get_tool_buttons():
#	# edit existing
#	if scene_id in Dialogue._flows:
#		var meta_data: Dictionary = Dialogue._flows[scene_id].M
#		var file_path: String = meta_data.file
#		var file_line: int = meta_data.line
#		return [{
#			text="Edit %s" % file_path.get_file(),
#			call="@SELECT_AND_EDIT;%s" % file_path,
#			hint="Edit %s." % file_path
#		}]
#	else:
#		# file exists
#		var new_path := "res://dialogue/%s.%s" % [scene_id, Soot.EXT_DIALOGUE]
#		if UFile.exists(new_path):
#			return [{
#				text="Edit %s" % new_path.get_file(),
#				call="@SELECT_AND_EDIT;%s" % new_path,
#				hint="Edit %s." % new_path
#			}]
#
#		# create new
#		else:
#
#			var new_data := "=== %s\n\t=== started\n\t\tHello world.\n\t\tStarted scene %s." % [scene_id, scene_id.capitalize()]
#			return [{
#				text="Create %s" % [new_path.get_file()],
#				call="@CREATE_AND_EDIT;%s;%s" % [new_path, new_data],
#				hint="Create %s." % new_path}]
