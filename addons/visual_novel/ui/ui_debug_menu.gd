extends CanvasLayer

@onready var debug_menu = $debug_menu

func _ready() -> void:
	visible = false
	debug_menu.process_mode = Node.PROCESS_MODE_DISABLED
	SaveManager.loaded.connect(_hide)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug") and VisualNovel.debug.allow_debug_menu:
		if visible:
			_hide()
		else:
			_show()

func _hide():
	visible = false
	debug_menu.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false

func _show():
	Global.snap_screenshot()
	visible = true
	debug_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
