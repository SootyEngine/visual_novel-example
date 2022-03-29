extends Node

@export var _resolution: NodePath
@onready var resolution: OptionButton = get_node(_resolution)

@export var _full_screen: NodePath
@onready var full_screen: CheckBox = get_node(_full_screen)

@export var _music_mute: NodePath
@export var _music_volume: NodePath
@onready var music_mute: CheckBox = get_node(_music_mute)
@onready var music_volume: HSlider = get_node(_music_volume)

@export var _sfx_mute: NodePath
@export var _sfx_volume: NodePath
@onready var sfx_mute: CheckBox = get_node(_sfx_mute)
@onready var sfx_volume: HSlider = get_node(_sfx_volume)

func _ready() -> void:
	await get_tree().process_frame
	
	resolution.item_selected.connect(_set_resolution)
	
	full_screen.button_pressed = Settings._get("full_screen")
	full_screen.toggled.connect(func(x): Settings._set("full_screen", x))
	
	music_mute.button_pressed = not Settings._get("music_mute")
	music_mute.toggled.connect(func(x): Settings._set("music_mute", not x))
	music_volume.value = Settings._get("music_volume")
	music_volume.value_changed.connect(func(x): Settings._set("music_volume", x))
	
	sfx_mute.button_pressed = not Settings._get("sfx_mute")
	sfx_mute.toggled.connect(func(x): Settings._set("sfx_mute", not x))
	sfx_volume.value = Settings._get("sfx_volume")
	sfx_volume.value_changed.connect(func(x): Settings._set("sfx_volume", x))

func _set_resolution(index: int):
	var r := resolution.get_item_text(index)
	var p := r.split("x")
	if len(p) == 2:
		Settings._set("resolution", Vector2i(p[0].to_int(), p[1].to_int()))
	else:
		push_error("Malformed resolution: %s." % r)
		return Vector2i.ZERO

