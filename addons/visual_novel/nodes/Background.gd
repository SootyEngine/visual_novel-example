@tool
extends Sprite2D

@export var alternatives: Array[Resource] = []
var current := "":
	set = set_current

var _tween: Tween

func _get_property_list() -> Array:
	return PropList.new()\
		.category("Background")\
		.prop_enum("current", TYPE_STRING, get_alternative_ids())\
		.done()

func get_alternative_ids():
	return alternatives.map(func(x: Texture): return UFile.get_file_name(x.resource_path))

func set_current(id: String):
	var index = get_alternative_ids().find(id)
	if index != -1:
		current = id
		fade_to(alternatives[index])

func set_current_immediate(id: String):
	var index = get_alternative_ids().find(id)
	if index != -1:
		current = id
		set_texture(alternatives[index])

func fade_to(next: Texture):
	SpriteTransitions.blend(self, next, _tween)

func _get_tool_buttons():
	return [center]

func center():
	position = Global.window_size * .5

