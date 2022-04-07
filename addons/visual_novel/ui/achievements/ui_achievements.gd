extends Node

@export var _prefab: NodePath
@export var _parent: NodePath
@onready var prefab: Node = get_node(_prefab)
@onready var parent: Node = get_node(_parent)

func _ready() -> void:
	parent.remove_child(prefab)
	
	await get_tree().process_frame
	Mods.loaded.connect(_connect)

func _connect():
	var awards: Awards = Persistent.awards
	awards.unlocked.connect(_update)
	awards.progress.connect(_update)
	_update()

func _update(_x=null):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
	
	for id in Persistent.awards:
		var a: Award = Persistent.awards[id]
		var btn = prefab.duplicate()
		parent.add_child(btn)
		btn.get_child(0)._setup(a)
		btn.get_child(1).pressed.connect(Persistent._set.bind("awards.%s.tick"%id, a.tick-1))
		btn.get_child(2).pressed.connect(Persistent._set.bind("awards.%s.tick"%id, a.tick+1))
