@tool
extends Node
class_name SootButton

const FADEOUT_TIME := 0.25

@export var goto_scene := ""
@export var goto_scene_flow := ""
@export var action := ""
@export var condition_visible := ""
@export var fadeout_on_diabled := false
var _tween: Tween

func _init() -> void:
	if not Engine.is_editor_hint():
		DialogueStack.started.connect(_disable)
		DialogueStack.ended.connect(_enable)
		self.pressed.connect(_on_pressed)
		process_mode = Node.PROCESS_MODE_ALWAYS

func _get_property_list() -> Array:
	var props := PropList.new().category("SootButton")
	if owner and "scene_file_path" in owner:
		# scene ids
		props.prop_enum("goto_scene", TYPE_STRING, Scene.get_main_scene_ids())
		
		# scene flow ids
		var file := UFile.get_file_name(owner.scene_file_path) + ".soot"
		var path := UFile.get_file_in_dir("res://dialogue", file)
		if path:
			var scene_flows: Array = DialogueParser.new().parse(path).flows.keys()
			props.prop_enum("goto_scene_flow", TYPE_STRING, scene_flows)
	
	return props.done()

func _disable():
	self.disabled = true
	
	if fadeout_on_diabled:
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.bind_node(self)
		_tween.tween_property(self, "modulate:a", 0.0, FADEOUT_TIME)
		_tween.tween_callback(self.set_visible.bind(false))

func _enable():
	self.disabled = false
	
	if fadeout_on_diabled:
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween()
		_tween.bind_node(self)
		_tween.tween_callback(self.set_visible.bind(true))
		_tween.tween_property(self, "modulate:a", 1.0, FADEOUT_TIME)

func _ready() -> void:
	if len(condition_visible):
		self.visible = true if State._eval(condition_visible) else false

func _on_pressed() -> void:
	if has_method("release_focus"):
		self.release_focus()
	
	if action:
		if DialogueStack.can_do(action):
			DialogueStack.do(action)
		else:
			StringAction.do(action)
	
	if goto_scene_flow:
		DialogueStack.goto(Soot.join_path([Scene.id, goto_scene_flow]))
	
	if not len(action) and not len(goto_scene_flow):
		push_warning("No action or goto_scene_flow in %s." % self)
