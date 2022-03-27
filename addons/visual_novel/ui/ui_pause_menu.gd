extends CanvasLayer

@export var _buttons: NodePath
@onready var buttons: Control = get_node(_buttons)
@export var _save_load_screen: NodePath
@onready var save_load_screen: Control = get_node(_save_load_screen)

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Saver.loaded.connect(_hide)

func _ready() -> void:
	_hide()
	save_load_screen.visible = false
	
	for item in buttons.get_children():
		if item is Button:
			prints("BUTTON", item, item.name)
			if item.name == "continue":
				print("is continue")
				item.pressed.connect(_hide)
			if item.name == "save":
				print("is save")
				item.pressed.connect(_show_save_menu)
			if item.name =="load":
				print("is load")
				item.pressed.connect(_show_load_menu)
				# TODO: Are you sure?
			if item.name =="main_menu":
				item.pressed.connect(StringAction.do.bind("@scene main_menu"))

func _show_save_menu():
	print("clicked")
	save_load_screen.visible = true
	save_load_screen.save_mode = true

func _show_load_menu():
	save_load_screen.visible = true
	save_load_screen.save_mode = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("toggle ", visible)
		
		if visible:
			_hide()
		elif get_tree().current_scene is SootScene:
			_show()
			
		get_viewport().set_input_as_handled()

func _hide():
	if visible:
		visible = false
		get_tree().paused = false
		save_load_screen.visible = false

func _show():
	if not visible:
		visible = true
		get_tree().paused = true
		Global.snap_screenshot()
