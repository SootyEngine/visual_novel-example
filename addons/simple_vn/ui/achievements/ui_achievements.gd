extends Node

@export var _prefab: NodePath
@export var _parent: NodePath
@onready var prefab: Node = get_node(_prefab)
@onready var parent: Node = get_node(_parent)

func _ready() -> void:
	parent.remove_child(prefab)
	
	_ready_deferred.call_deferred()
	Global.message.connect(_global_message)

func _global_message(msg: String, payload: Variant):
	match msg:
		Achievement.MSG_ACHIEVEMENT_PROGRESS, Achievement.MSG_ACHIEVEMENT_UNLOCKED:
			_ready_deferred()

func _ready_deferred():
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
	
	var achievements := Persistent._get_all_of_type(Achievement)
	for id in achievements:
		var a: Achievement = achievements[id]
		var btn = prefab.duplicate()
		parent.add_child(btn)
		btn.get_child(0)._setup(a)
		btn.get_child(1).pressed.connect(Persistent._set.bind(id+".tick", a.tick-1))
		btn.get_child(2).pressed.connect(Persistent._set.bind(id+".tick", a.tick+1))
