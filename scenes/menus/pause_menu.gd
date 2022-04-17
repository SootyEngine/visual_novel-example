extends Control

@export var _buttons: NodePath
@onready var buttons: Control = get_node(_buttons)

@export var _screen_parent: NodePath
@onready var screen_parent: Control = get_node(_screen_parent)

@export var _save_load_screen: NodePath
@onready var save_load_screen: Control = get_node(_save_load_screen)

@export var _settings_screen: NodePath
@onready var settings_screen: Control = get_node(_settings_screen)

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	SaveManager.loaded.connect(_hide)
	
	_hide()
	save_load_screen.visible = false
	settings_screen.visible = false
	
	for item in buttons.get_children():
		if item is Button:
			match str(item.name):
				"continue": item.pressed.connect(_hide)
				"settings": item.pressed.connect(_show_settings_screen)
				"save": item.pressed.connect(_show_save_screen)
				"load": item.pressed.connect(_show_load_screen)
				"main_menu": item.pressed.connect(_goto_main_menu)

func _goto_main_menu():
	# TODO: Are you sure?
	_hide()
	Global.end()
	SceneManager.goto("main_menu")

func _hide_screens():
	for child in screen_parent.get_children():
		child.visible = false

func _show_settings_screen():
	_hide_screens()
	settings_screen.visible = true

func _show_save_screen():
	_hide_screens()
	save_load_screen.visible = true
	save_load_screen.save_mode = true

func _show_load_screen():
	_hide_screens()
	save_load_screen.visible = true
	save_load_screen.save_mode = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_hide()
		elif VisualNovel.is_scene():
			_show()
			
		get_viewport().set_input_as_handled()

func _hide():
	if visible:
		visible = false
		_hide_screens()
		get_tree().paused = false
		save_load_screen.visible = false

func _show():
	if not visible:
		visible = true
		get_tree().paused = true
		Global.snap_screenshot()
