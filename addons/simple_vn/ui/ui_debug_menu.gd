extends CanvasLayer

@onready var debug_menu = $debug_menu

var _screenshot: Image

func _ready() -> void:
	visible = false
	debug_menu.process_mode = Node.PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		if visible:
			visible = false
			debug_menu.process_mode = Node.PROCESS_MODE_DISABLED
			get_tree().paused = false
			
		else:
			_screenshot = get_viewport().get_texture().get_image()
			
			visible = true
			debug_menu.process_mode = Node.PROCESS_MODE_ALWAYS
			get_tree().paused = true
