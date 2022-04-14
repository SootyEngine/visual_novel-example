@tool
extends Node
class_name SootButton

const FADEOUT_TIME := 0.25

@export var goto_scene := ""
@export var goto_scene_flow := ""
@export var action := ""
@export var condition_visible := ""
@export var fadeout_on_disabled := false
var _tween: Tween

#func _init() -> void:
#	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	Dialogue.started.connect(_disable)
	Dialogue.ended.connect(_enable)
	self.pressed.connect(_on_pressed)
	
	if len(condition_visible):
		self.visible = true if State._eval(condition_visible) else false
	
	if Dialogue.is_active():
		if fadeout_on_disabled:
			self.modulate.a = 0.0

func _get_property_list() -> Array:
	var props := PropList.new().category("SootButton")
	if owner and "scene_file_path" in owner:
		# scene ids
		props.prop_enum("goto_scene", TYPE_STRING, Scene.get_main_scene_ids())
		
		# scene flow ids
		var file: String = "%s.%s" % [UFile.get_file_name(owner.scene_file_path), Soot.EXT_DIALOGUE]
		var path := UFile.get_file_in_dir("res://dialogue", file)
		if path:
			var scene_flows: Array = DialogueParser.new().parse(path).flows.keys()
			props.prop_enum("goto_scene_flow", TYPE_STRING, scene_flows)
	
	return props.done()

func _init_tween():
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.bind_node(self)
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

func _disable():
	self.disabled = true
	
	if fadeout_on_disabled:
		_init_tween()
		_tween.tween_property(self, "modulate:a", 0.0, FADEOUT_TIME)
		_tween.tween_callback(self.set_visible.bind(false))

func _enable():
	self.disabled = false
	
	if fadeout_on_disabled:
		_init_tween()
#		_tween.tween_interval(.1)
		_tween.tween_callback(self.set_visible.bind(true))
		_tween.tween_property(self, "modulate:a", 1.0, FADEOUT_TIME)

func _on_pressed() -> void:
	if has_method("release_focus"):
		self.release_focus()
	
	if action:
		if Dialogue.can_do(action):
			Dialogue.do(action)
		else:
			StringAction.do(action)
	
	elif goto_scene_flow:
		Dialogue.goto(Soot.join_path([Scene.id, goto_scene_flow]))
	
	elif goto_scene:
		Scene.goto(goto_scene)
	
	else:
		push_warning("No action or goto_scene_flow or goto_scene in %s." % self)
