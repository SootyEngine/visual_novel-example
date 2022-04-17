@tool
extends EditorPlugin

var plugin
var scene_buttons := HBoxContainer.new()
var edited_scene: Node = null

func _enter_tree():
	plugin = preload("res://addons/tool_button/tool_button_inspector.gd").new(self)
	add_inspector_plugin(plugin)
	
	scene_buttons.add_to_group("_scene_buttons_")
	_refresh_buttons()
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_BOTTOM, scene_buttons)
	
	get_editor_interface().get_selection().selection_changed.connect(_selection_changed)

func _selection_changed():
	var scene := get_editor_interface().get_edited_scene_root()
	if edited_scene != scene:
		edited_scene = scene
		print("Changed scene.")
		_refresh_buttons.call_deferred()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.ctrl_pressed and event.keycode == KEY_QUOTELEFT:
			scene_buttons.visible = not scene_buttons.visible
			get_viewport().set_input_as_handled()

func _add_scene_button(text: String, call: Callable, kwargs := {}):
	var btn := Button.new()
	btn.text = text
	btn.flat = true
	for k in kwargs:
		btn[k] = kwargs[k]
	btn.pressed.connect(func(): call.call())
	scene_buttons.add_child(btn)

func _add_seperator():
	var sep := VSeparator.new()
	scene_buttons.add_child(sep)

func _refresh_buttons():
	# remove old buttons
	for child in scene_buttons.get_children():
		scene_buttons.remove_child(child)
		child.queue_free()
	
	# readd the refresh button
	_add_scene_button("~", _refresh_buttons)
	
	# add scene buttons
	for node in get_tree().get_nodes_in_group("has_scene_buttons"):
		if node.has_method("_get_editor_buttons"):
			_add_seperator()
			var btns =  node._get_editor_buttons()
			if btns:
				for btn in btns:
					_add_scene_button(btn.text, btn.call)
		else:
			push_error("No method _get_editor_buttons in %s." % node)
	
	# TODO: let user add own controls
	# for instance, a console for running commands
	
#	var margin := Control.new()
#	margin.size_flags_horizontal = HORIZONTAL_ALIGNMENT_FILL
#	scene_buttons.add_child(margin)
#
#	var console := LineEdit.new()
#	console.size_flags_horizontal = HORIZONTAL_ALIGNMENT_FILL
#	console.placeholder_text = "> Console"
##	console.minimum_size.x = 120
#	scene_buttons.add_child(console)

func _exit_tree():
	remove_inspector_plugin(plugin)
	
	scene_buttons.queue_free()
	
	# really try to get rid of the buttons
	for node in get_tree().get_nodes_in_group("_scene_buttons_"):
		node.queue_free()

func rescan_filesystem():
	var fs = get_editor_interface().get_resource_filesystem()
	fs.update_script_classes()
	fs.scan_sources()
	fs.scan()
